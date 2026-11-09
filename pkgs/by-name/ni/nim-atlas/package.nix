{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nix-update-script,
  openssl,
}:

let
  # Atlas needs the dep in a certain place, easier to download and and place in deps/ folder
  sat = fetchFromGitHub {
    owner = "nim-lang";
    repo = "sat";
    # The atlas nimble file (https://github.com/nim-lang/atlas/blob/master/atlas.nimble) doesn't
    # provide a version and upstream sat package has no version tags. This is the latest commit
    # as of 2026-08-14
    rev = "9d52513b3c68bfb929dbd687d4fb2836cfee6936";
    hash = "sha256-y9kFjYFrmVejIE8fSh4AehaNnCO/UISssrnGwwcnJLk=";
  };
in
buildNimPackage (
  final: prev: rec {
    pname = "atlas";
    version = "0.16.3";
    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "atlas";
      rev = "${version}";
      hash = "sha256-Lsb/m1r9NIy44OtdfDvEjPVLjfkXg0/9AUbnOPbXyPM=";
    };
    buildInputs = [ openssl ];
    preConfigure = ''
      mkdir deps
      cp -r ${sat} deps/sat
    '';
    doCheck = false; # tests will clone repos
    passthru.updateScript = nix-update-script { };
    meta = final.src.meta // {
      description = "Nim package cloner";
      mainProgram = "atlas";
      license = lib.licenses.mit;
    };
  }
)
