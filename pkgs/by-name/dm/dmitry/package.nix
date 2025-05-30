{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "dmitry";
  version = "1.3a-unstable-2020-06-22";

  src = fetchFromGitHub {
    owner = "jaygreig86";
    repo = "dmitry";
    rev = "f3ae08d4242e3e178271c827b86ff0d655972280";
    hash = "sha256-cYFeBM8xFMaLXYk6Rg+5JvfbbIJI9F3mefzCX3+XbB0=";
  };

  patches = [ ./implicit-function-declaration.patch ];

  nativeBuildInputs = [ autoreconfHook ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fcommon" ];

  meta = {
    description = "Deepmagic Information Gathering Tool";
    mainProgram = "dmitry";
    homepage = "https://github.com/jaygreig86/dmitry";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
