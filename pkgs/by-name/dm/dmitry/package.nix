{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "dmitry";
  version = "1.3a-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "jaygreig86";
    repo = "dmitry";
    rev = "f2b8961dabbd55486a5649a9803446b860ad28e7";
    hash = "sha256-ZEfRaJ4ds1yWxN9VTFoBiUI5ZzK//aD7o9ry6vmA1YM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Deepmagic Information Gathering Tool";
    mainProgram = "dmitry";
    homepage = "https://github.com/jaygreig86/dmitry";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
