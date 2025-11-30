{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "par2cmdline";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    rev = "v${version}";
    hash = "sha256-io9Ofep3t2EJrHBX9gft+JJflYRp0bRX+zFnOFIAsTw=";
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

  passthru.updateScript = nix-update-script { };
}
