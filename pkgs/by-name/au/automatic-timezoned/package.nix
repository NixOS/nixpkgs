{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
  version = "2.0.45";

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8fgOhmjFXC0nMs7oTfJWbn1DOmOU9RtTgR+xmV/nZ9g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OimAHyx6UdNB6RIGa+LN5Xy63L7VbTj7lazZyUQXy1s=";

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
