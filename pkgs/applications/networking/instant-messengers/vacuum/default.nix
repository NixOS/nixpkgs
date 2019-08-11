{ stdenv, fetchFromGitHub
  , qt4, qmake4Hook, openssl
  , xorgproto, libX11, libXScrnSaver
  , xz, zlib
}:
stdenv.mkDerivation rec {
  name = "vacuum-im-${version}";
  version = "1.3.0.20160104";

  src = fetchFromGitHub {
    owner = "Vacuum-IM";
    repo = "vacuum-im";
    rev = "1.3.0.20160104-Alpha";
    sha256 = "1jcw9c7s75y4c3m4skfc3cc0i519z39b23n997vj5mwcjplxyc76";
  };

  buildInputs = [
    qt4 openssl xorgproto libX11 libXScrnSaver xz zlib
  ];

  # hack: needed to fix build issues in
  # http://hydra.nixos.org/build/38322959/nixlog/1
  # should be an upstream issue but it's easy to fix
  NIX_LDFLAGS = "-lz";

  nativeBuildInputs = [ qmake4Hook ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags INSTALL_PREFIX=$out"
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "An XMPP client fully composed of plugins";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = http://www.vacuum-im.org;
  };
}
