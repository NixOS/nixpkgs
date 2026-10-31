{
  lib,
  fetchFromGitHub,
  stdenv,
  swift,
  swiftpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dark-mode-notify";
  version = "0-unstable-2022-07-18";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "dark-mode-notify";
    rev = "4d7fe211f81c5b67402fad4bed44995344a260d1";
    hash = "sha256-LsAQ5v5jgJw7KsJnQ3Mh6+LNj1EMHICMoD5WzF3hRmU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  makeFlags = [ "prefix=$(out)" ];

  dontUseSwiftpmInstall = true;

  meta = {
    description = "Run a script whenever dark mode changes in macOS";
    homepage = "https://github.com/bouk/dark-mode-notify";
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ YorikSar ];
    mainProgram = "dark-mode-notify";
  };
})
