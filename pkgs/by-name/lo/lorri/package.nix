{
  lib,
  pkgs,
  rustPackages,
  fetchFromGitHub,
  rustPlatform,
  writers,
  nixosTests,
}:

let
  # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
  # It will copy some required files if necessary.
  # Also don’t forget to run `nix-build -A lorri.tests`
  version = "1.7.1";
  sha256 = "sha256-dEdKMgE4Jd8CCvtGQDZNDCYOomZAV8aR7Cmtyn8RfTo=";
  cargoHash = "sha256-pRtc0cDVIBqbCbC1weFOhZP29rKAE1XdmM6HE5nJKRU=";

in
(rustPlatform.buildRustPackage rec {
  pname = "lorri";
  inherit version;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lorri";
    rev = version;
    inherit sha256;
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  inherit cargoHash;
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix { };

  nativeBuildInputs = [ rustPackages.rustfmt ];

  # copy the docs to the $man and $doc outputs
  postInstall = ''
    install -Dm644 lorri.1 $man/share/man/man1/lorri.1
    install -Dm644 -t $doc/share/doc/lorri/ \
      README.md \
      CONTRIBUTING.md \
      LICENSE \
      MAINTAINERS.md
    cp -r contrib/ $doc/share/doc/lorri/contrib
  '';

  passthru = {
    updater = writers.writeBash "copy-runtime-nix.sh" ''
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };

  meta = with lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/nix-community/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [
      grahamc
      Profpatsch
      nyarly
    ];
    mainProgram = "lorri";
  };
})
