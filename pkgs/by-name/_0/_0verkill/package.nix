{
  lib,
  gccStdenv,
  fetchFromGitHub,
  autoreconfHook,
  xorgproto,
  libX11,
  libXpm,
}:

gccStdenv.mkDerivation {
  pname = "0verkill";
  version = "0-unstable-2011-01-13";

  src = fetchFromGitHub {
    owner = "hackndev";
    repo = "0verkill";
    rev = "522f11a3e40670bbf85e0fada285141448167968";
    sha256 = "WO7PN192HhcDl6iHIbVbH7MVMi1Tl2KyQbDa9DWRO6M=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libX11
    xorgproto
    libXpm
  ];

  configureFlags = [ "--with-x" ];

  # The code needs an update for gcc-10:
  #   https://github.com/hackndev/0verkill/issues/7
  env.NIX_CFLAGS_COMPILE = "-fcommon";
  hardeningDisable = [ "all" ]; # Someday the upstream will update the code...

  meta = {
    homepage = "https://github.com/hackndev/0verkill";
    description = "ASCII-ART bloody 2D action deathmatch-like game";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
