{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stress";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "stress";
    tag = finalAttrs.version;
    hash = "sha256-1r0n/KE4RpO0txIViGxuc7G+I4Ds9AJYcuMx2/R97jg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "stress";
  };
})
