{
  haskell,
  lib,
  stdenv,
  coreutils,
  libsecret,
  gnupg,
  makeBinaryWrapper,
  withLibsecret ? true, # default oama config uses libsecret
  withGpg ? false,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides = {
    description = "OAuth credential MAnager";
    homepage = "https://github.com/pdobsan/oama";

    passthru.updateScript = ./update.sh;

    buildDepends = [
      makeBinaryWrapper
    ];

    postInstall = ''
      wrapProgram $out/bin/oama \
        --prefix PATH : ${
          lib.makeBinPath (
            [ coreutils ] ++ lib.optional withLibsecret libsecret ++ lib.optional withGpg gnupg
          )
        }
    '';
  };

  raw-pkg = haskell.packages.ghc912.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  # FIXME: eliminate all erroneous references on aarch64-darwin manually,
  # see https://github.com/NixOS/nixpkgs/issues/318013
  (
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      lib.id
    else
      justStaticExecutables
  )
]
