# Getting the Sources {#sec-getting-sources}

By default, NixOS's `nixos-rebuild` command uses the NixOS and Nixpkgs
sources provided by the `nixos` channel (kept in
`/nix/var/nix/profiles/per-user/root/channels/nixos`). To modify NixOS,
however, you should check out the latest sources from Git. This is as
follows:

```ShellSession
$ git clone https://github.com/NixOS/nixpkgs
$ cd nixpkgs
$ git remote update origin
```

This will check out the latest Nixpkgs sources to `./nixpkgs` the NixOS
sources to `./nixpkgs/nixos`. (The NixOS source tree lives in a
subdirectory of the Nixpkgs repository.) The `nixpkgs` repository has
branches that correspond to each Nixpkgs/NixOS channel (see
[](#sec-upgrading) for more information about channels). Thus, the
Git branch `origin/nixos-17.03` will contain the latest built and tested
version available in the `nixos-17.03` channel.

It's often inconvenient to develop directly on the master branch, since
if somebody has just committed (say) a change to GCC, then the binary
cache may not have caught up yet and you'll have to rebuild everything
from source. So you may want to create a local branch based on your
current NixOS version:

```ShellSession
$ nixos-version
17.09pre104379.6e0b727 (Hummingbird)

$ git checkout -b local 6e0b727
```

Or, to base your local branch on the latest version available in a NixOS
channel:

```ShellSession
$ git remote update origin
$ git checkout -b local origin/nixos-17.03
```

(Replace `nixos-17.03` with the name of the channel you want to use.)
You can use `git merge` or `git
  rebase` to keep your local branch in sync with the channel, e.g.

```ShellSession
$ git remote update origin
$ git merge origin/nixos-17.03
```

You can use `git cherry-pick` to copy commits from your local branch to
the upstream branch.

If you want to rebuild your system using your (modified) sources, you
need to tell `nixos-rebuild` about them using the `-I` flag:

```ShellSession
# nixos-rebuild switch -I nixpkgs=/my/sources/nixpkgs
```

If you want `nix-env` to use the expressions in `/my/sources`, use
`nix-env -f
  /my/sources/nixpkgs`, or change the default by adding a symlink in
`~/.nix-defexpr`:

```ShellSession
$ ln -s /my/sources/nixpkgs ~/.nix-defexpr/nixpkgs
```

You may want to delete the symlink `~/.nix-defexpr/channels_root` to
prevent root's NixOS channel from clashing with your own tree (this may
break the command-not-found utility though). If you want to go back to
the default state, you may just remove the `~/.nix-defexpr` directory
completely, log out and log in again and it should have been recreated
with a link to the root channels.
