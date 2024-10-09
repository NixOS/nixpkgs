{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, gettext
, libtool
, perl
, pkg-config
, glib
, xorg
}:
stdenv.mkDerivation rec {
  pname = "xdg-launch";
  version = "1.12";

  postPatch = ''
    # fix gettext configuration
    echo 'AM_GNU_GETTEXT_VERSION' >> configure.ac
    echo 'AM_GNU_GETTEXT([external])' >> configure.ac

    sed -i data/*.desktop \
      -e "s,/usr/bin,/$out/bin,g"
  '';

  src = fetchFromGitHub {
    owner = "bbidulock";
    repo = pname;
    rev = version;
    sha256 = "sha256-S/0Wn1T5MSOPN6QXkzfmygHL6XTAnnMJr5Z3fBzsHEw=";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [
    xorg.libX11
    xorg.libXrandr
    glib # can be optional
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    perl # pod2man
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://github.com/bbidulock/xdg-launch";
    description = "Command line XDG compliant launcher and tools";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.ck3d ];
  };
}
