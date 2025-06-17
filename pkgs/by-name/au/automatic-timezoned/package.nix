{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.79";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${version}";
    sha256 = "sha256-FPSwTtLLf1T4lx4ZmPPa6dnhcI9pBCFjhsABeIccRKk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-H4bFSqt8hOH6tF2WO1mQqqmbK9U2qlFC+7swz/xj1I8=";

  meta = {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ maxbrunet ];
    platforms = lib.platforms.linux;
    mainProgram = "automatic-timezoned";
  };
}
