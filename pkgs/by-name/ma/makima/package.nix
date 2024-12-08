{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec{
  pname = "makima";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-yKaUDFrUEXXgYaGKuFnuViAEet2BVh1ZbGRo6wuC69g=";
  };

  cargoHash = "sha256-rtVO1pmWI2U+m8RVHjPEi++OtsLEjmXkhzpg6UkgNuE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.linux;
    mainProgram = "makima";
  };
}
