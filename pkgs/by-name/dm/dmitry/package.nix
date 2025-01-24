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

  nativeBuildInputs = [ autoreconfHook ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fcommon" ];

  meta = with lib; {
    description = "Deepmagic Information Gathering Tool";
    mainProgram = "dmitry";
    homepage = "https://github.com/jaygreig86/dmitry";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
