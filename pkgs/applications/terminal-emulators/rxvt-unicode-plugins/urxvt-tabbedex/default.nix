{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-tabbedex";
  version = "22.32";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "v${version}";
    sha256 = "sha256-4+4iPFoy1j5xjXRM5kBauhff44Y7/ik/+ZLZ1prc+Xo=";
  };

  nativeBuildInputs = [ perl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = "https://github.com/mina86/urxvt-tabbedex";
    maintainers = [ ];
    platforms = with platforms; unix;
    license = lib.licenses.gpl3Plus;
  };
}
