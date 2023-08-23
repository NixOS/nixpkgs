{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "workstyle";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = pname;
    rev = "8bde72d9a9dd67e0fc7c0545faca53df23ed3753";
    sha256 = "sha256-yhnt7edhgVy/cZ6FpF6AZWPoeMeEKTXP+87no2KeIYU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "swayipc-3.0.1" = "sha256-3Jhz3+LhncSRvo3n7Dh5d+RWQSvEff9teuaDZLLLEHk=";
    #   "flash-lso-0.5.0" = "sha256-9uH3quxRzLtmHJs5WF/GRxWkXL/KFyOl182HKcHNnuc=";
    #   "gc-arena-0.2.2" = "sha256-/H9VcTesBD+IA7bUf208b0HQ/cIUDAz9TJBBywf6akA=";
    #   "h263-rs-0.1.0" = "sha256-4kBg09VHyiQTvUbvcTb5g/BVcOpRFZ1fVEuRWXv5XwE=";
    #   "nellymoser-rs-0.1.2" = "sha256-GykDQc1XwySOqfxW/OcSxkKCFJyVmwSLy/CEBcwcZJs=";
    #   "nihav_codec_support-0.1.0" = "sha256-rE9AIiQr+PnHC9xfDQULndSfFHSX4sqKkCAQYVNaJcQ=";
    };
  };

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
