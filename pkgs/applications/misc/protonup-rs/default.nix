{ config
, pkgs
, lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "protonup-rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "Protonup-rs";
    rev = "main";
    sha256 = "sha256-IDxFK0+p5OFycKJHpw+QNCEIIF0bRRLO7tZzwiQ4IaA=";
  };

  cargoSha256 = "sha256-0oaE5ZmKozEr41SNOcyz0yynUov+ynu2RlSUNLsv4yE=";

  # Can't seem to make test work when enabled? Network access?
  # github::tests::test_fetch_data_from_tag
  doCheck = false;

  meta = with lib; {
    description = "Lib, CLI and GUI(wip) program to automate the installation and update of Proton-GE";
    homepage = "https://github.com/auyer/Protonup-rs/";
    mainProgram = "protonup-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ liperium ];
    platforms = [ "x86_64-linux" ];
  };
}
