{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  testers,
  porsmo,
}:

rustPlatform.buildRustPackage rec {
  pname = "porsmo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ColorCookie-dev";
    repo = "porsmo";
    rev = version;
    hash = "sha256-bYPUSrGJKoNLFkIiGuXraYoaYn/HKSP8IiH3gtyWfmw=";
  };

  cargoHash = "sha256-zkeQY0YNcKfyaWHmv1N61dBggsvFzz1fgkjXkyYK3Lg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
  ];

  passthru.tests.version = testers.testVersion {
    package = porsmo;
  };

  meta = with lib; {
    description = "Pomodoro cli app in rust with timer and countdown";
    homepage = "https://github.com/ColorCookie-dev/porsmo";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
    mainProgram = "porsmo";
  };
}
