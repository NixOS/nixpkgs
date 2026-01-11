{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mt-st";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "iustin";
    repo = "mt-st";
    tag = "v${version}";
    hash = "sha256-Sl+/v+ko3K4npY/M49H1YDxqOMy923qcAkTohi5Xg70=";
  };

  installFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
    "COMPLETIONINSTALLDIR=$(out)/share/bash-completion/completions"
  ];

  meta = {
    description = "Magnetic Tape control tools for Linux";
    longDescription = ''
      Fork of the standard "mt" tool with additional Linux-specific IOCTLs.
    '';
    homepage = "https://github.com/iustin/mt-st";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.linux;
  };
}
