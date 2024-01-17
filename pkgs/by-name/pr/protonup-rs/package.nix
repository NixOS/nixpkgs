{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "protonup-rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "auyer";
    repo = "Protonup-rs";
    rev = "v${version}";
    hash = "sha256-IE8QO9LaEllTYRRDA704SNWp4Ap2NQmoYMaKX4l9McY=";
  };

  cargoSha256 = "sha256-04EabrIlLwKPbrNIaJXi1WEDOdX3ojZrds5izzOymIg=";

  # Can't seem to make test work when enabled? Network access?
  # github::tests::test_fetch_data_from_tag, github::tests::test_get_release, github::tests::test_list_releases
  checkFlags = [
    "--skip={github::tests::test_fetch_data_from_tag, github::tests::test_get_release, github::tests::test_list_releases}"
  ];

  meta = with lib; {
    description = "Lib, CLI and GUI(wip) program to automate the installation and update of Proton-GE";
    homepage = "https://github.com/auyer/Protonup-rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ liperium ];
    platforms = [ "x86_64-linux" ];
  };
}
