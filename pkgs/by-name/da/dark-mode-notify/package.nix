{
  lib,
  fetchFromGitHub,
  stdenv,
  swift,
  swiftpm,
  swiftPackages,
}:

# Use the same stdenv, including clang, as Swift itself
# Fixes build issues, see https://github.com/NixOS/nixpkgs/pull/296082 and https://github.com/NixOS/nixpkgs/issues/295322
swiftPackages.stdenv.mkDerivation (final: {
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

  meta = {
    description = "Run a script whenever dark mode changes in macOS";
    homepage = "https://github.com/bouk/dark-mode-notify";
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ YorikSar ];
    mainProgram = "dark-mode-notify";
  };
})
