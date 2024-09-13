{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "par2cmdline";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    rev = "v${version}";
    sha256 = "11mx8q29cr0sryd11awab7y4mhqgbamb1ss77rffjj6in8pb4hdk";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/Parchive/par2cmdline";
    description = "PAR 2.0 compatible file verification and repair tool";
    longDescription = ''
      par2cmdline is a program for creating and using PAR2 files to detect
      damage in data files and repair them if necessary. It can be used with
      any kind of file.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
