# Nix's Perl bindings. They were dropped from Nix itself in 2.35 and are now
# maintained in the Hydra repository:
# https://github.com/NixOS/hydra/commit/1dd13469091cd25656cfa0db4b8a353c1a2c26e7
{
  lib,
  stdenv,
  src,
  bzip2,
  curl,
  libsodium,
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

    sourceRoot = "${finalAttrs.src.name}/subprojects/nix-perl";

    nativeBuildInputs = [
      curl
      meson
      ninja
      perl
      pkg-config
    ];

    buildInputs = [
      bzip2
      libsodium
      nix-store
      perlPackages.DBDSQLite
      perlPackages.DBI
    ];

    preConfigure = ''
      echo ${finalAttrs.version} > .version
    '';

    mesonBuildType = "release";

    mesonFlags = [
      (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    ];

    mesonCheckFlags = [ "--print-errorlogs" ];

    # `perlPackages.Test2Harness` is marked broken for Darwin
    doCheck = !stdenv.hostPlatform.isDarwin;

    nativeCheckInputs = [
      perlPackages.Test2Harness
    ];

    strictDeps = false;

    meta = {
      description = "Perl bindings for the Nix store, as maintained in the Hydra repository";
      homepage = "https://github.com/NixOS/hydra";
      license = lib.licenses.lgpl21Plus;
      platforms = lib.platforms.unix;
    };
  })
)
