{
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  jq,
  nurl,
}:

stdenv.mkDerivation {
  name = "swiftpm2nix";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./swiftpm2nix.sh} $out/bin/swiftpm2nix
    wrapProgram $out/bin/$name \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          nurl
        ]
      } \
  '';

  preferLocalBuild = true;

  passthru = callPackage ./support.nix { };

  meta = {
    description = "Generate a Nix expression to fetch swiftpm dependencies";
    mainProgram = "swiftpm2nix";
    maintainers = lib.teams.swift.members;
    platforms = lib.platforms.all;
  };
}
