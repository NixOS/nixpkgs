# Nix's Perl bindings. They were dropped from Nix itself in 2.35 and are now
# maintained in the Hydra repository:
# https://github.com/NixOS/hydra/commit/1dd13469091cd25656cfa0db4b8a353c1a2c26e7
{
  lib,
  stdenv,
  src,
  meson,
  ninja,
  nix-store,
  perl,
  perlPackages,
  pkg-config,
}:
perl.pkgs.toPerlModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "nix-perl";
    inherit (nix-store) version;
    inherit src;

    __structuredAttrs = true;
    strictDeps = true;

    sourceRoot = "${finalAttrs.src.name}/subprojects/nix-perl";

    nativeBuildInputs = [
      meson
      ninja
      perl
      pkg-config
    ];

    buildInputs = [
      nix-store
      # We compile against perl's CORE headers, which `#include <crypt.h>` from
      # the `libxcrypt` perl propagates.
      perl
      perlPackages.DBDSQLite
      perlPackages.DBI
    ];

    preConfigure = ''
      echo ${finalAttrs.version} > .version
    ''
    # Upstream's `meson.build` compiles `Store.xs` against perl's `CORE` headers but without perl's
    # own `ccflags`.
    # Some of those (e.g. `-DNO_POSIX_2008_LOCALE` on Darwin) change the layout of
    # `PerlInterpreter`, so the module then fails the XS handshake on load.
    + ''
      export NIX_CFLAGS_COMPILE+=" $(perl -MConfig -e 'print join " ", grep { /^-D/ } split " ", $Config{ccflags}')"
    '';

    mesonBuildType = "release";

    mesonFlags = [
      (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    ];

    mesonCheckFlags = [ "--print-errorlogs" ];

    doCheck = true;

    nativeCheckInputs = [
      perlPackages.Test2Harness
    ];

    meta = {
      description = "Perl bindings for the Nix store, as maintained in the Hydra repository";
      homepage = "https://github.com/NixOS/hydra";
      license = lib.licenses.lgpl21Plus;
      platforms = lib.platforms.unix;
    };
  })
)
