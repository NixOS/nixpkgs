{
  lib,
  mkMesonDerivation,

  doxygen,

  # Configuration Options

  version,
}:

mkMesonDerivation (finalAttrs: {
  pname = "nix-internal-api-docs";
  inherit version;

  workDir = ./.;

  nativeBuildInputs = [
    doxygen
  ];

  preConfigure = ''
    chmod u+w ./.version
    echo ${finalAttrs.version} > ./.version
  '';

  postInstall = ''
    mkdir -p ''${!outputDoc}/nix-support
    echo "doc internal-api-docs $out/share/doc/nix/internal-api/html" >> ''${!outputDoc}/nix-support/hydra-build-products
  '';

  meta = {
    platforms = lib.platforms.all;
  };
})
