# Citrix Workspace {#sec-citrix}

The [Citrix Workspace App](https://www.citrix.com/products/workspace-app/) is a remote desktop viewer which provides access to [XenDesktop](https://www.citrix.com/products/xenapp-xendesktop/) installations.

## Basic usage {#sec-citrix-base}

The tarball archive needs to be downloaded manually, as the license agreements of the vendor for [Citrix Workspace](https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html) needs to be accepted first. Then run `nix-prefetch-url file://$PWD/linuxx64-$version.tar.gz`. With the archive available in the store, the package can be built and installed with Nix.

## Citrix Self-service {#sec-citrix-selfservice}

The [self-service](https://support.citrix.com/article/CTX200337) is an application managing Citrix desktops and applications. Please note that this feature only works with at least citrix_workspace_20_06_0 and later versions.

In order to set this up, you first have to [download the `.cr` file from the Netscaler Gateway](https://its.uiowa.edu/support/article/102186). After that, you can configure the `selfservice` like this:

```ShellSession
$ storebrowse -C ~/Downloads/receiverconfig.cr
$ selfservice
```

## Custom certificates {#sec-citrix-custom-certs}

The `Citrix Workspace App` in `nixpkgs` trusts several certificates [from the Mozilla database](https://curl.haxx.se/docs/caextract.html) by default. However, several companies using Citrix might require their own corporate certificate. On distros with imperative packaging, these certs can be stored easily in [`$ICAROOT`](https://citrix.github.io/receiver-for-linux-command-reference/), however this directory is a store path in `nixpkgs`. In order to work around this issue, the package provides a simple mechanism to add custom certificates without rebuilding the entire package using `symlinkJoin`:

```nix
with import <nixpkgs> { config.allowUnfree = true; };
let
  extraCerts = [
    ./custom-cert-1.pem
    ./custom-cert-2.pem # ...
  ];
in citrix_workspace.override { inherit extraCerts; }
```
