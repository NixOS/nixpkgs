{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  coreutils,
  gnutar,
  gzip,
  makeWrapper,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix-bundle";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "nix-bundle";
    rev = "v${finalAttrs.version}";
    sha256 = "0js8spwjvw6kjxz1i072scd035fhiyazixvn84ibdnw8dx087gjv";
  };

  nativeBuildInputs = [ makeWrapper ];

  # coreutils, gnutar are needed by nix for bootstrap
  buildInputs = [
    bzip2
    coreutils
    gnutar
    gzip
    nix
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/share/nix-bundle/nix-bundle.sh $out/bin/nix-bundle \
      --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
    ln -s $out/share/nix-bundle/nix-run.sh $out/bin/nix-run
  '';

  meta = {
    homepage = "https://github.com/matthewbauer/nix-bundle";
    description = "Create bundles from Nixpkgs attributes";
    longDescription = ''
      nix-bundle is a way to package Nix attributes into single-file
      executables.

      Benefits:
      - Single-file output
      - Can be run by non-root users
      - No runtime
      - Distro agnostic
      - No installation
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
