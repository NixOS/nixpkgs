{
  lib,
  python3,
  runCommand,
  makeWrapper,
  path,
  fetchgit,
  nurl,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      joblib
      platformdirs
      click
      click-log
    ]
  );

in

runCommand "gclient2nix"
  {
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ python ];

    # substitutions
    nixpkgs_path = if builtins.pathExists (path + "/.git") then lib.cleanSource path else path;
    depot_tools_checkout = fetchgit {
      url = "https://chromium.googlesource.com/chromium/tools/depot_tools";
      rev = "452fe3be37f78fbecefa1b4b0d359531bcd70d0d";
      hash = "sha256-8IiJOm0FLa/u1Vd96tb33Ruj4IUTCeYgBpTk88znhPw=";
    };
  }
  ''
    mkdir -p $out/bin
    substituteAll ${./gclient2nix.py} $out/bin/gclient2nix
    chmod u+x $out/bin/gclient2nix
    patchShebangs $out/bin/gclient2nix
    wrapProgram $out/bin/gclient2nix --set PATH "${lib.makeBinPath [ nurl ]}"
  ''
