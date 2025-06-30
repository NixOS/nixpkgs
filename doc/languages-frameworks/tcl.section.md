# Tcl {#sec-language-tcl}

## User guide {#sec-language-tcl-user-guide}

Tcl interpreters are available under the `tcl` and `tcl-X_Y` attributes, where `X_Y` is the Tcl version.

Tcl libraries are available in the `tclPackages` attribute set.
They are only guaranteed to work with the default Tcl version, but will probably also work with others thanks to the [stubs mechanism](https://wiki.tcl-lang.org/page/Stubs).

## Packaging guide {#sec-language-tcl-packaging}

Tcl packages are typically built with `tclPackages.mkTclDerivation`.
Tcl dependencies go in `buildInputs`/`nativeBuildInputs`/... like other packages.
For more complex package definitions, such as packages with mixed languages, use `tcl.tclPackageHook`.

Where possible, make sure to enable stubs for maximum compatibility, usually with the `--enable-stubs` configure flag.

Here is a simple package example to be called with `tclPackages.callPackage`.

```
{ lib, fetchzip, mkTclDerivation, openssl }:

mkTclDerivation rec {
  pname = "tcltls";
  version = "1.7.22";

  src = fetchzip {
    url = "https://core.tcl-lang.org/tcltls/uv/tcltls-${version}.tar.gz";
    hash = "sha256-TOouWcQc3MNyJtaAGUGbaQoaCWVe6g3BPERct/V65vk=";
  };

  buildInputs = [ openssl ];

  configureFlags = [
    "--with-ssl-dir=${openssl.dev}"
    "--enable-stubs"
  ];

  meta = {
    homepage = "https://core.tcl-lang.org/tcltls/index";
    description = "OpenSSL / RSA-bsafe Tcl extension";
    maintainers = [ lib.maintainers.agbrooks ];
    license = lib.licenses.tcltk;
    platforms = lib.platforms.unix;
  };
}
```

All Tcl libraries are declared in `pkgs/top-level/tcl-packages.nix` and are defined in `pkgs/development/tcl-modules/`.
If possible, prefer the by-name hierarchy in `pkgs/development/tcl-modules/by-name/`.
Its use is documented in `pkgs/development/tcl-modules/by-name/README.md`.

All Tcl applications reside elsewhere.
In case a package is used as both a library and an application (for example `expect`), it should be defined in `tcl-packages.nix`, with an alias elsewhere.
