{ stdenv, lib, fetchgit, pkg-config, meson, ninja
, enchant, gtkmm3, libchamplain, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "lifeograph";
  version = "2.0.2";

  src = fetchgit {
    url = "https://git.launchpad.net/lifeograph";
    # Specific commit hash related to version
    rev = "d635bbb30011c0d33c33643e6fa5c006f98ed7d6";
    sha256 = "0j9wn5bj7cbfnmyyx7ikx961sksv50agnb53prymldbsq43rfgnq";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    enchant
    gtkmm3
    libchamplain
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/net.sourceforge.Lifeograph.desktop \
      --replace "Exec=" "Exec=$out/bin/"
  '';

  meta = with lib; {
    homepage = "http://lifeograph.sourceforge.net/wiki/Main_Page";
    description = "Lifeograph is an off-line and private journal and note taking application";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = platforms.linux;
  };
}
