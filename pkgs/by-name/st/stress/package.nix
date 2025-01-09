{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "stress";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    hash = "sha256-1r0n/KE4RpO0txIViGxuc7G+I4Ds9AJYcuMx2/R97jg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "stress";
  };
}
