{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.74";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${version}";
    sha256 = "sha256-rPZCZ0BH5k+73dcMThPOLBw0t5oHPSa5HOjR9bE2MG0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8EnBw1IQWlMIyh13nC7fCpnbfM4T9B8okM1FNXZ4mgQ=";

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
    mainProgram = "automatic-timezoned";
  };
}
