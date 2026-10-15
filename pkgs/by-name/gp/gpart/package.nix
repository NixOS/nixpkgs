{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpart";
  version = "0.3";

  # GitHub repository 'collating patches for gpart from all distributions':
  src = fetchFromGitHub {
    hash = "sha256-yhMqG2n32EippjvxZQWpJ/sEfZm4a6PTJCRdc9BMTdM=";
    rev = finalAttrs.version;
    repo = "gpart";
    owner = "baruch";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  doCheck = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Guess PC-type hard disk partitions";
    longDescription = ''
      Gpart is a tool which tries to guess the primary partition table of a
      PC-type hard disk in case the primary partition table in sector 0 is
      damaged, incorrect or deleted. The guessed table can be written to a file
      or device.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gpart";
  };
})
