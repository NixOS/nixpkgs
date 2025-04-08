{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.67";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${version}";
    sha256 = "sha256-j7wQ7jUiXpiDdGBDSiGkIcnnrwkJZESiwB4yqxp0moU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AIZnpE9ULyZnKNOtpoTP1VQYXMAxEuDiHWdEJGiGo5Q=";

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
