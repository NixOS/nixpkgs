{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, alsa-lib
, stdenv
, darwin
, testers
, porsmo
}:

rustPlatform.buildRustPackage rec {
  pname = "porsmo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ColorCookie-dev";
    repo = "porsmo";
    rev = version;
    hash = "sha256-NOMEfS6RvB9513ZkcQi6cxBuhmALqqcI3onhua2MD+0=";
  };

  cargoHash = "sha256-6RV1RUkWLaxHqvs2RqSe/2tDw+aPDoRBYUW1GxN18Go=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  passthru.tests.version = testers.testVersion {
    package = porsmo;
  };

  meta = with lib; {
    description = "Pomodoro cli app in rust with timer and countdown";
    homepage = "https://github.com/ColorCookie-dev/porsmo";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
