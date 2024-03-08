# Emacs {#module-services-emacs}

<!--
    Documentation contributors:
      Damien Cassou @DamienCassou
      Thomas Tuegel @ttuegel
      Rodney Lorrimar @rvl
      Adam Hoese @adisbladis
  -->

[Emacs](https://www.gnu.org/software/emacs/) is an
extensible, customizable, self-documenting real-time display editor — and
more. At its core is an interpreter for Emacs Lisp, a dialect of the Lisp
programming language with extensions to support text editing.

Emacs runs within a graphical desktop environment using the X Window System,
but works equally well on a text terminal. Under
macOS, a "Mac port" edition is available, which
uses Apple's native GUI frameworks.

Nixpkgs provides a superior environment for
running Emacs. It's simple to create custom builds
by overriding the default packages. Chaotic collections of Emacs Lisp code
and extensions can be brought under control using declarative package
management. NixOS even provides a
{command}`systemd` user service for automatically starting the Emacs
daemon.

## Installing Emacs {#module-services-emacs-installing}

Emacs can be installed in the normal way for Nix (see
[](#sec-package-management)). In addition, a NixOS
*service* can be enabled.

### The Different Releases of Emacs {#module-services-emacs-releases}

Nixpkgs defines several basic Emacs packages.
The following are attributes belonging to the {var}`pkgs` set:

  {var}`emacs`
  : The latest stable version of Emacs using the [GTK 2](http://www.gtk.org)
    widget toolkit.

  {var}`emacs-nox`
  : Emacs built without any dependency on X11 libraries.

  {var}`emacsMacport`
  : Emacs with the "Mac port" patches, providing a more native look and
    feel under macOS.

If those aren't suitable, then the following imitation Emacs editors are
also available in Nixpkgs:
[Zile](https://www.gnu.org/software/zile/),
[mg](http://homepage.boetes.org/software/mg/),
[Yi](http://yi-editor.github.io/),
[jmacs](https://joe-editor.sourceforge.io/).

### Adding Packages to Emacs {#module-services-emacs-adding-packages}

Emacs includes an entire ecosystem of functionality beyond text editing,
including a project planner, mail and news reader, debugger interface,
calendar, and more.

Most extensions are gotten with the Emacs packaging system
({file}`package.el`) from
[Emacs Lisp Package Archive (ELPA)](https://elpa.gnu.org/),
[MELPA](https://melpa.org/),
[MELPA Stable](https://stable.melpa.org/), and
[Org ELPA](http://orgmode.org/elpa.html). Nixpkgs is
regularly updated to mirror all these archives.

Under NixOS, you can continue to use
`package-list-packages` and
`package-install` to install packages. You can also
declare the set of Emacs packages you need using the derivations from
Nixpkgs. The rest of this section discusses declarative installation of
Emacs packages through nixpkgs.

The first step to declare the list of packages you want in your Emacs
installation is to create a dedicated derivation. This can be done in a
dedicated {file}`emacs.nix` file such as:

::: {.example #ex-emacsNix}
### Nix expression to build Emacs with packages (`emacs.nix`)

```nix
/*
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/

# The first non-comment line in this file indicates that
# the whole file represents a function.
{ pkgs ? import <nixpkgs> {} }:

let
  # The let expression below defines a myEmacs binding pointing to the
  # current stable version of Emacs. This binding is here to separate
  # the choice of the Emacs binary from the specification of the
  # required packages.
  myEmacs = pkgs.emacs;
  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
  # The rest of the file specifies the list of packages to install. In the
  # example, two packages (magit and zerodark-theme) are taken from
  # MELPA stable.
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit          # ; Integrate git <C-x g>
    zerodark-theme # ; Nicolas' theme
  ])
  # Two packages (undo-tree and zoom-frm) are taken from MELPA.
  ++ (with epkgs.melpaPackages; [
    undo-tree      # ; <C-x u> to show the undo tree
    zoom-frm       # ; increase/decrease font size for all buffers %lt;C-x C-+>
  ])
  # Three packages are taken from GNU ELPA.
  ++ (with epkgs.elpaPackages; [
    auctex         # ; LaTeX mode
    beacon         # ; highlight my cursor when scrolling
    nameless       # ; hide current package name everywhere in elisp code
  ])
  # notmuch is taken from a nixpkgs derivation which contains an Emacs mode.
  ++ [
    pkgs.notmuch   # From main packages set
  ])
```
:::

The result of this configuration will be an {command}`emacs`
command which launches Emacs with all of your chosen packages in the
{var}`load-path`.

You can check that it works by executing this in a terminal:
```ShellSession
$ nix-build emacs.nix
$ ./result/bin/emacs -q
```
and then typing `M-x package-initialize`. Check that you
can use all the packages you want in this Emacs instance. For example, try
switching to the zerodark theme through `M-x load-theme <RET> zerodark <RET> y`.

::: {.tip}
A few popular extensions worth checking out are: auctex, company,
edit-server, flycheck, helm, iedit, magit, multiple-cursors, projectile,
and yasnippet.
:::

The list of available packages in the various ELPA repositories can be seen
with the following commands:
::: {.example #module-services-emacs-querying-packages}
### Querying Emacs packages

```
nix-env -f "<nixpkgs>" -qaP -A emacs.pkgs.elpaPackages
nix-env -f "<nixpkgs>" -qaP -A emacs.pkgs.melpaPackages
nix-env -f "<nixpkgs>" -qaP -A emacs.pkgs.melpaStablePackages
nix-env -f "<nixpkgs>" -qaP -A emacs.pkgs.orgPackages
```
:::

If you are on NixOS, you can install this particular Emacs for all users by
putting the `emacs.nix` file in `/etc/nixos` and adding it to the list of
system packages (see [](#sec-declarative-package-mgmt)). Simply modify your
file {file}`configuration.nix` to make it contain:
::: {.example #module-services-emacs-configuration-nix}
### Custom Emacs in `configuration.nix`

```
{
 environment.systemPackages = [
   # [...]
   (import ./emacs.nix { inherit pkgs; })
  ];
}
```
:::

In this case, the next {command}`nixos-rebuild switch` will take
care of adding your {command}`emacs` to the {var}`PATH`
environment variable (see [](#sec-changing-config)).

<!-- fixme: i think the following is better done with config.nix
https://nixos.org/nixpkgs/manual/#sec-modify-via-packageOverrides
-->

If you are not on NixOS or want to install this particular Emacs only for
yourself, you can do so by putting `emacs.nix` in `~/.config/nixpkgs` and
adding it to your {file}`~/.config/nixpkgs/config.nix` (see
[Nixpkgs manual](https://nixos.org/nixpkgs/manual/#sec-modify-via-packageOverrides)):
::: {.example #module-services-emacs-config-nix}
### Custom Emacs in `~/.config/nixpkgs/config.nix`

```
{
  packageOverrides = super: let self = super.pkgs; in {
    myemacs = import ./emacs.nix { pkgs = self; };
  };
}
```
:::

In this case, the next `nix-env -f '<nixpkgs>' -iA
myemacs` will take care of adding your emacs to the
{var}`PATH` environment variable.

### Advanced Emacs Configuration {#module-services-emacs-advanced}

If you want, you can tweak the Emacs package itself from your
{file}`emacs.nix`. For example, if you want to have a
GTK 3-based Emacs instead of the default GTK 2-based binary and remove the
automatically generated {file}`emacs.desktop` (useful if you
only use {command}`emacsclient`), you can change your file
{file}`emacs.nix` in this way:

::: {.example #ex-emacsGtk3Nix}
### Custom Emacs build

```
{ pkgs ? import <nixpkgs> {} }:
let
  myEmacs = (pkgs.emacs.override {
    # Use gtk3 instead of the default gtk2
    withGTK3 = true;
    withGTK2 = false;
  }).overrideAttrs (attrs: {
    # I don't want emacs.desktop file because I only use
    # emacsclient.
    postInstall = (attrs.postInstall or "") + ''
      rm $out/share/applications/emacs.desktop
    '';
  });
in [...]
```
:::

After building this file as shown in [](#ex-emacsNix), you
will get an GTK 3-based Emacs binary pre-loaded with your favorite packages.

## Running Emacs as a Service {#module-services-emacs-running}

NixOS provides an optional
{command}`systemd` service which launches
[Emacs daemon](https://www.gnu.org/software/emacs/manual/html_node/emacs/Emacs-Server.html)
with the user's login session.

*Source:* {file}`modules/services/editors/emacs.nix`

### Enabling the Service {#module-services-emacs-enabling}

To install and enable the {command}`systemd` user service for Emacs
daemon, add the following to your {file}`configuration.nix`:
```
services.emacs.enable = true;
```

The {var}`services.emacs.package` option allows a custom
derivation to be used, for example, one created by
`emacsWithPackages`.

Ensure that the Emacs server is enabled for your user's Emacs
configuration, either by customizing the {var}`server-mode`
variable, or by adding `(server-start)` to
{file}`~/.emacs.d/init.el`.

To start the daemon, execute the following:
```ShellSession
$ nixos-rebuild switch  # to activate the new configuration.nix
$ systemctl --user daemon-reload        # to force systemd reload
$ systemctl --user start emacs.service  # to start the Emacs daemon
```
The server should now be ready to serve Emacs clients.

### Starting the client {#module-services-emacs-starting-client}

Ensure that the Emacs server is enabled, either by customizing the
{var}`server-mode` variable, or by adding
`(server-start)` to {file}`~/.emacs`.

To connect to the Emacs daemon, run one of the following:
```
emacsclient FILENAME
emacsclient --create-frame  # opens a new frame (window)
emacsclient --create-frame --tty  # opens a new frame on the current terminal
```

### Configuring the {var}`EDITOR` variable {#module-services-emacs-editor-variable}

<!--<title>{command}`emacsclient` as the Default Editor</title>-->

If [](#opt-services.emacs.defaultEditor) is
`true`, the {var}`EDITOR` variable will be set
to a wrapper script which launches {command}`emacsclient`.

Any setting of {var}`EDITOR` in the shell config files will
override {var}`services.emacs.defaultEditor`. To make sure
{var}`EDITOR` refers to the Emacs wrapper script, remove any
existing {var}`EDITOR` assignment from
{file}`.profile`, {file}`.bashrc`,
{file}`.zshenv` or any other shell config file.

If you have formed certain bad habits when editing files, these can be
corrected with a shell alias to the wrapper script:
```
alias vi=$EDITOR
```

### Per-User Enabling of the Service {#module-services-emacs-per-user}

In general, {command}`systemd` user services are globally enabled
by symlinks in {file}`/etc/systemd/user`. In the case where
Emacs daemon is not wanted for all users, it is possible to install the
service but not globally enable it:
```
services.emacs.enable = false;
services.emacs.install = true;
```

To enable the {command}`systemd` user service for just the
currently logged in user, run:
```
systemctl --user enable emacs
```
This will add the symlink
{file}`~/.config/systemd/user/emacs.service`.

## Configuring Emacs {#module-services-emacs-configuring}

If you want to only use extension packages from Nixpkgs, you can add
`(setq package-archives nil)` to your init file.

After the declarative Emacs package configuration has been tested,
previously downloaded packages can be cleaned up by removing
{file}`~/.emacs.d/elpa` (do make a backup first, in case you
forgot a package).

<!--
      todo: is it worth documenting customizations for
      server-switch-hook, server-done-hook?
  -->

### A Major Mode for Nix Expressions {#module-services-emacs-major-mode}

Of interest may be {var}`melpaPackages.nix-mode`, which
provides syntax highlighting for the Nix language. This is particularly
convenient if you regularly edit Nix files.

### Accessing man pages {#module-services-emacs-man-pages}

You can use `woman` to get completion of all available
man pages. For example, type `M-x woman <RET> nixos-rebuild <RET>.`

### Editing DocBook 5 XML Documents {#sec-emacs-docbook-xml}

Emacs includes
[nXML](https://www.gnu.org/software/emacs/manual/html_node/nxml-mode/Introduction.html),
a major-mode for validating and editing XML documents. When editing DocBook
5.0 documents, such as [this one](#book-nixos-manual),
nXML needs to be configured with the relevant schema, which is not
included.

To install the DocBook 5.0 schemas, either add
{var}`pkgs.docbook5` to [](#opt-environment.systemPackages)
([NixOS](#sec-declarative-package-mgmt)), or run
`nix-env -f '<nixpkgs>' -iA docbook5`
([Nix](#sec-ad-hoc-packages)).

Then customize the variable {var}`rng-schema-locating-files` to
include {file}`~/.emacs.d/schemas.xml` and put the following
text into that file:
::: {.example #ex-emacs-docbook-xml}
### nXML Schema Configuration (`~/.emacs.d/schemas.xml`)

```xml
<?xml version="1.0"?>
<!--
  To let emacs find this file, evaluate:
  (add-to-list 'rng-schema-locating-files "~/.emacs.d/schemas.xml")
-->
<locatingRules xmlns="http://thaiopensource.com/ns/locating-rules/1.0">
  <!--
    Use this variation if pkgs.docbook5 is added to environment.systemPackages
  -->
  <namespace ns="http://docbook.org/ns/docbook"
             uri="/run/current-system/sw/share/xml/docbook-5.0/rng/docbookxi.rnc"/>
  <!--
    Use this variation if installing schema with "nix-env -iA pkgs.docbook5".
  <namespace ns="http://docbook.org/ns/docbook"
             uri="../.nix-profile/share/xml/docbook-5.0/rng/docbookxi.rnc"/>
  -->
</locatingRules>
```
:::
