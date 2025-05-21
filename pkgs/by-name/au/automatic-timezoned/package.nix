{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.75";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${version}";
    sha256 = "sha256-DEHnMgHJTpf2t7iqaYC7AvG8Su4dTCCalnEwP75T8rA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b6f6BDIPygXvXKEXxzy2KW/khk5RuUIhgBfcB30IqQc=";

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
