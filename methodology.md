# Survey of potential `<|` and `|>` usage in Nixpkgs

The idea is to pick some random representative sample of Nixpkgs file, and try to find function calls that would improve by using `<|` or `|>`.
Deciding what is an improvement is tricky, and there are a lot of situations where one could use the operators but whether that's better or not can be a matter of taste.

Especially, there are many cases where the usage of the operator can replace a set of parentheses, however not all parentheses are "bad".
Therefore, I try to limit myself to more obvious cases.
Also, sometimes, either operator would be an improvement, but which one to use is a matter of taste.

Additionally, whether or not a change is an improvement depends on the used code formatting style and its interactions with it.
For example, a couple of lines in Nixpkgs use `flip` in order to swap the arguments, but only to improve formatting and not out of necessity.
Those can usually be improved by removing the `flip` using `<|` before the last argument instead.
I am going to try to be faithful to the style currently used in any file, although I'd like to mention that using the operators can provide some interesting formatting improvements with the currently WIP style proposal from the Formatting RFC. (TODO: expand on this once it's less WIP)

On a last note, some code examples may profit from using one of the new operators but doing so would require touching a couple more lines.
Examples are let bindings which only exist for the purpose of reducing parentheses, but which could be inlined with the use of piping.
Some of that code would simply have been written differently in the first place.
I try to do these kind of changes where possible, however it is very difficult since I am not familiar with the existing code so I might miss a lot of opportunities.

To summarize, I've been extremely conservative about any changes and strongly biased towards status quo in situations where there is not much of a difference between the options. (I might also have missed a couple of instances.)
Among many others, the following code patterns would be applicable to piping yet were not changed in this experiment
(f, g, h, ... are function names, a, b, c, ... are argument names, capital letters indicate multiline expressions):

```nix
f (g a)
# f <| g a
# f <| g <| a
# a |> g |> f
# g a |> f

f a (g b)
# f a <| g b
# f a <| g <| b
# b |> g |> f a
# g b |> f a

f A B
# f A
#   <| B
```

Piping has been done in these cases (not exhaustive):

```nix
f (g a b)
# f <| g a b
# f <| g a <| b
# g a b |> f
# b |> g a |> f

f a (g b c)
# f a <| g b c
# f a <| g b <| c
# g b c |> f a
# c |> g b |> f a

f (g (h a b))
# f <| g <| h a b
# f <| g <| h a <| b
# b |> h a |> g |> f
# h a b |> g |> f

f a B c
# c |> f a B
# f a B
#   <| c
```

The comments describe different ways the given expression could be transformed using pipe operators.
While some of them may look nonsensical here, all of them have their uses depending on what the code does and how large the individual sub-expressions actually are.

## Experiment 1

Take a look at 10 random files from `pkgs`, and 5 from `lib` and `nixos`, respectively.

Commands run to choose files at random:

```
fd -g "**.nix" pkgs | shuf -n 10 | sort
fd -g "**.nix" nixos | shuf -n 5 | sort
fd -g "**.nix" lib | shuf -n 5 | sort
```

Chosen files:

- `pkgs/applications/networking/cluster/nixops/poetry-git-overlay.nix`
- `pkgs/applications/office/activitywatch/wrapper.nix`
- `pkgs/development/compilers/gerbil/gerbil-crypto.nix`
- `pkgs/development/libraries/qt-5/modules/qtdatavis3d.nix`
- `pkgs/development/ocaml-modules/camlimages/default.nix`
- `pkgs/development/python-modules/py-bip39-bindings/default.nix`
- `pkgs/development/python-modules/pyxnat/default.nix`
- `pkgs/development/tools/misc/usb-modeswitch/default.nix`
- `pkgs/os-specific/linux/device-tree/default.nix`
  - Usage of `flip` can be replaced by `|>`
    - Note that `flip` here was used to improve formatting and not out of necessity
- `pkgs/servers/icingaweb2/ipl.nix`
- `nixos/modules/installer/netboot/netboot-base.nix`
- `nixos/modules/services/hardware/auto-cpufreq.nix`
- `nixos/modules/services/monitoring/grafana.nix`
  - Parentheses can be replaced by `<|` or a two-`|>` pipeline when flipping the order
- `nixos/modules/services/x11/desktop-managers/gnome.nix`
- `nixos/tests/buildkite-agents.nix`
- `lib/tests/modules/declare-lazyAttrsOf.nix`
- `lib/tests/modules/define-module-check.nix`
- `lib/tests/modules/define-value-int-positive.nix`
- `lib/tests/modules/disable-declare-enable.nix`
- `lib/tests/modules/import-from-store.nix`

Only two changes were made here. It is to note that many of the files are rather simple and short, so there simply is no need.
Both changes happened in comparatively large and complex files.

## Experiment 2

This time, filter out files with less than 100 lines of code as "trivial". Also double the sampling size.

Commands:

```
# Filterin is done by a silly grep on lines with at least three consecutive digits
fd -g "**.nix" pkgs  | xargs wc -l --total=never | rg '^\s*\d{3,} ' | shuf -n 20 | sort
fd -g "**.nix" nixos | xargs wc -l --total=never | rg '^\s*\d{3,} ' | shuf -n 10 | sort
fd -g "**.nix" lib   | xargs wc -l --total=never | rg '^\s*\d{3,} ' | shuf -n 10 | sort
```

Chosen files:

- `pkgs/development/misc/haskell/hasura/graphql-engine.nix`
- `pkgs/development/tools/comby/default.nix`
- `pkgs/development/compilers/ponyc/default.nix`
- `pkgs/tools/security/tracee/default.nix`
- `pkgs/development/python-modules/cypherpunkpay/default.nix`
- `pkgs/development/libraries/amdvlk/default.nix`
- `pkgs/applications/networking/p2p/freenet/default.nix`
- `pkgs/applications/video/streamlink-twitch-gui/bin.nix`
- `pkgs/tools/graphics/gmic-qt/default.nix`
  - `lib.assertMsg` call could make use of piping, although it wouldn't be a big improvement
- `pkgs/servers/windmill/default.nix`
- `pkgs/applications/video/manim/default.nix`
- `pkgs/development/interpreters/python/pypy/prebuilt_2_7.nix`
- `pkgs/top-level/lua-packages.nix`
- `pkgs/applications/networking/instant-messengers/teams/default.nix`
- `pkgs/applications/networking/instant-messengers/zoom-us/default.nix`
- `pkgs/tools/networking/curl/default.nix`
- `pkgs/desktops/deepin/go-package/startdde/deps.nix`
- `pkgs/development/compilers/llvm/7/default.nix`
- `pkgs/development/compilers/llvm/11/default.nix`
- `pkgs/applications/editors/rstudio/yarndeps.nix`
- `nixos/tests/caddy.nix`
- `nixos/modules/system/boot/initrd-network.nix`
  - Parentheses can be replaced by `<|` or two `|>`. The latter additionally allows removing parentheses around one of the arguments.
- `nixos/modules/services/networking/gnunet.nix`
- `nixos/modules/services/cluster/hadoop/yarn.nix`
- `nixos/modules/services/misc/etebase-server.nix`
- `nixos/tests/postgresql.nix`
- `nixos/modules/services/misc/autosuspend.nix`
  - Has some deeply nested function calls, although due to a lambda abstraction only an inner layer can be converted
  - Has a classic `f (g (h a))` pipeable function call
- `nixos/modules/services/networking/3proxy.nix`
  - Has two `concatMapStringsSep` calls where the mapper is very long, hiding the last argument input. It can be moved to the front of the call with `|>`. This is one of the situations where one might have used a `flip` to do the same thing.
  - Off-topic: I'd like to forbid nesting string interpolations this deeply; this is atrocious
- `nixos/modules/services/misc/paperless.nix`
  - One applicable `f a (g b c)` call
- `nixos/modules/virtualisation/libvirtd.nix`
- `lib/licenses.nix`
  - One use of `lib.pipe` can be replaced with `|>` calls
  - One let binding can be inlined together with some function calls, although this is unrelated to piping
- `lib/fixed-points.nix`
- `lib/systems/inspect.nix`
  - `f a (g b (h c))` function call
- `lib/systems/doubles.nix`
  - Has two function calls which could be changed but are not really worth it. However, one is exclusively used in the other, so inlining results in a neat combined pipeline.
- `lib/meta.nix`
  - Has a deeply nested and complex function call of kind `f a (g b (h c (i d)))`, a prime use case for a long pipeline
- `lib/filesystem.nix`
  - Has a pipeline equivalent written out in form of a let binding, can be converted. The first call in the resulting pipe has the form `f (g a)` and could thus split into the pipe too, however due to a code comment I kept it as a single unit instead.
  - One more such let binding and another nested function call
- `lib/customisation.nix`
  - Contains one long `lib.pipe` call
  - Two `flip` calls, one of them can be replaced by a pipe while simultaneously inlining a let binding
  - A lot of various nested function calls that can be piped
  - Probably some more potential by inlining some attributes in let bindings, which I didn't do
- `lib/systems/examples.nix`
- `lib/systems/parse.nix`
  - One `f (g (h a b))` call
- `lib/lists.nix`
  - A lot of interesting function calls, however none of them were really interesting for piping despite deep nesting. This is a combination of short expressions that fit one line, and functions with two arguments that are similar in shape, thus special-casing one of them for a pipe would make no sense.

## Experiment 3

The previous experiments got me curious about how `flip` is used in Nixpkgs.
So let's grep for it and have a look.

- `nixos/lib/systemd-lib.nix`
  - `flip all (splitString ":" s) (bytes: …)`, used to move the long lambda to the end
  - `lib/customisation.nix` see above. The non-pipable flip call is on a single function argument, and itself passed to a function again, so it's very likely necessary here
- `nixos/lib/testing/network.nix`
  - Move the lambda of `concatMapStrings` to the end
- `pkgs/top-level/stage.nix`
  - `lib.foldl' (lib.flip lib.extends) (self: {}) …` As in `lib/customisation.nix`, `extends` is involved in the flip, although this time as argument and not as called function.
- `pkgs/top-level/release-lib.nix`,
  `pkgs/top-level/pkg-config/defaultPkgConfigPackages.nix`,
  `pkgs/tools/security/pinentry/default.nix`,
  `pkgs/tools/nix/nix-init/get-nix-license.nix`,
  - move lambda of `lib.mapAttrs'`/`lib.mapAttrs`/`map`/`concatMapAttrs` to the end
- `pkgs/tools/nix/nix-init/get-nix-license.nix`
  - `flip pipe` for point-free function (instead of `arg: pipe arg […]`)
- `pkgs/top-level/coq-packages.nix`
  - Partially apply a function in its second argument, pass the result as lambda to `makeScope`
- `lib/types.nix`
  - Partially apply a function in its second argument
- `nixos/modules/config/shells-environment.nix`,
  `nixos/modules/config/users-groups.nix`,
  `nixos/lib/make-options-doc/default.nix`,
  `nixos/tests/initrd-secrets.nix`
  - `mapAttrs`/`mapAttrsToList`/`map`/`genAttrs`, again
- `nixos/tests/lvm2/default.nix`
  - One flip of an import call to fix the second argument, unclear what the first one is.
  - Two flip calls on `concatMap` and `mapAttrsToList` to move the long argument to the end
- `nixos/tests/networking.nix`,
  `nixos/modules/config/system-environment.nix`,
  `nixos/tests/wireguard/default.nix`,
  `nixos/modules/system/boot/modprobe.nix`,
  `nixos/modules/system/boot/initrd-ssh.nix`,
  `nixos/modules/system/boot/loader/grub/grub.nix`,
  `nixos/modules/virtualisation/qemu-vm.nix`,
  `nixos/modules/tasks/network-interfaces-systemd.nix`,
  `nixos/modules/tasks/network-interfaces.nix`,
  `nixos/modules/tasks/network-interfaces-scripted.nix`,
  `nixos/modules/tasks/filesystems.nix`,
  `nixos/modules/programs/ssh.nix`,
  `nixos/modules/services/mail/sympa.nix`,
  `nixos/modules/system/boot/networkd.nix`,
  `nixos/modules/programs/yabar.nix`,
  `nixos/modules/services/mail/mailman.nix`,
  `nixos/modules/services/web-apps/bookstack.nix`,
  `nixos/modules/services/web-apps/keycloak.nix`,
  `nixos/modules/services/x11/xserver.nix`,
  `nixos/modules/services/web-servers/nginx/default.nix`,
  `nixos/modules/services/security/authelia.nix`,
  `nixos/modules/services/security/privacyidea.nix`,
  `nixos/modules/services/web-apps/monica.nix`,
  `nixos/modules/services/web-apps/discourse.nix`,
  `nixos/modules/services/security/fail2ban.nix`,
  `nixos/modules/services/web-apps/snipe-it.nix`
  - Swapping argument order of various lib functions to move the longest argument to the end
- `nixos/modules/services/monitoring/grafana.nix`,
  - Partially apply a function in its second argument
- `nixos/modules/services/monitoring/parsedmarc.nix`,
  `nixos/modules/services/networking/supybot.nix`,
  `nixos/modules/services/networking/dhcpd.nix`,
  `nixos/modules/services/networking/firewall-iptables.nix`,
  `nixos/modules/services/networking/i2pd.nix`,
  `nixos/modules/services/networking/jitsi-videobridge.nix`,
  `nixos/modules/services/networking/supplicant.nix`,
  `nixos/modules/services/networking/tinc.nix`,
  `nixos/modules/services/networking/wpa_supplicant.nix`,
  `nixos/modules/services/networking/pdns-recursor.nix`,
  `nixos/modules/services/networking/consul.nix`,
  `nixos/modules/services/misc/geoipupdate.nix`,
  `nixos/modules/services/networking/ncdns.nix`,
  `nixos/modules/services/misc/xmr-stak.nix`,
  `nixos/modules/services/security/opensnitch.nix`,
  `nixos/modules/services/misc/gitlab.nix`,
  `nixos/modules/services/monitoring/ups.nix`,
  `nixos/modules/services/monitoring/unpoller.nix`,
  `nixos/modules/services/networking/ssh/sshd.nix`,
  `nixos/modules/services/network-filesystems/tahoe.nix`
  - More of the same
- `nixos/modules/services/networking/hylafax/systemd.nix`,
  `pkgs/development/libraries/science/math/cudnn/generic.nix`
  - Flipped pipe
- `nixos/modules/services/monitoring/prometheus/exporters.nix`,
  `nixos/modules/services/networking/jibri/default.nix`,
  `nixos/modules/services/databases/cassandra.nix`,
  `nixos/modules/services/continuous-integration/github-runners.nix`,
  `pkgs/stdenv/generic/make-derivation.nix`
  - Business as usual
- `pkgs/stdenv/adapters.nix`,
  `pkgs/servers/irc/inspircd/default.nix`,
  `nixos/doc/manual/default.nix`
  - Partially apply a function's second argument
- `nixos/modules/hardware/device-tree.nix`,
  `nixos/modules/services/monitoring/thanos.nix`,
  `nixos/maintainers/option-usages.nix`,
  `pkgs/servers/http/nginx/generic.nix`,
  `pkgs/os-specific/windows/cygwin-setup/default.nix`,
  `pkgs/development/ruby-modules/bundled-common/default.nix`,
  `pkgs/development/libraries/opencv/4.x.nix`,
  `pkgs/development/libraries/glibc/common.nix`,
  `pkgs/build-support/go/package.nix`,
  `pkgs/applications/science/math/wolfram-engine/l10ns.nix`,
  `pkgs/applications/science/math/mathematica/versions.nix`,
  `pkgs/applications/office/libreoffice/default.nix`
  - You guessed it
- `pkgs/applications/editors/vscode/extensions/default.nix`
  - Passed `flip extends` into a `fold` again. Maybe `extends` has its arguments the wrong way in the first place?
- `pkgs/build-support/coq/default.nix`
  - `flip remove` passed to `foldl`. So maybe it's a `foldl` problem instead?
- `nixos/doc/manual/release-notes/rl-1909.section.md`
  - Mentions that there is now `lib.forEach` as preferred alternative to `flip map`

## Observations

- Almost all pipe operations happen around some kind of data processing using library functions.
  - Simple `mkDerivation` packages do this the least, especially the many small packages have no need. In larger packages, there occasionally are some relevant data manipulations.
  - There is a lot of helper code around package collections, generic packages (packages with many different variants around a common base), and build support. It frequently uses data processing which may benefit from piping. However this does not really show that much in the tests above, because those build-support files are drowned in the vast majority of small and simple packages.
  - Modules contain mostly pretty simple options declarations, however the logic in the let binding at the top and the configuration-generating bit at the bottom regularly does some more involved data processing. Especially when submodules are involved.
  - Unsurprisingly, `lib` code has the most potential for using pipe operators.
- This means that new users who mostly do simple packaging tasks are unlikely to come into contact with those operators or even need them. However, they provide some significant code style benefits for the experienced users which maintain the underlying infrastructure.
- There are usually four ways to transform a nested function call into a pipeline. Two options for the directions times whether or not the last/first argument should be a separate pipeline step or not.
  - This may seem abundant, but every function call is different in how its arguments actually look like. Having these options allows programmers to pick the one which has the best reading flow.
- Currently, there are a couple of workarounds for Nix' lack of function composition to reduce parentheses and nesting:
  - Using `let` bindings with an attribute for each major step. This has the disadvantage of quickly getting mixed into *actual* let-binding attributes, with no scope separation between parts of the pipe which are used only once and those who are relevant for the `in`. Furthermore, every part must be given a distinct name, and attributes are recursive by default which may lead to accidents. Finally, the examples I've seen so far used some pretty ~~unreadable~~ creative formatting to keep the let bindings reasonably compact.
  - Using `flip` to move the longest argument to the end. This especially looks weird with functions with more than two arguments, since it then requires to use parentheses around some of them. Arguably, a `flip` call like this is harder to read for beginners than `|>`.
  - Creating combined helper functions like `concatMapStringsSep` for very common combinations of function calls.
- One could try to add more workarounds like these to remove the need for pipe operators. For example a `flip23`, or even dedicated variants of common library functions that have the longest argument last. Also, use `pipe` more.
  - Just to be clear, I don't recommend this at all, but we *could*.

## Conclusion

- The introduction of pipe operators would be mostly benefitial to advanced users, while not significantly increasing the learning curve of the language for beginners.
- Having both operator directions allow more expressivity, although in many cases it doesn't matter that much, therefore only one of them would be fine too.
- Most current uses of `flip` can be removed and replaced with pipes.
