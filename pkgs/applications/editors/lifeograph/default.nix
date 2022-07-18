{ stdenv, lib, fetchgit, pkg-config, meson, ninja
, enchant, gtkmm3, libchamplain, libgcrypt, shared-mime-info }:

stdenv.mkDerivation rec {
  pname = "lifeograph";
  version = "2.0.3";

  src = fetchgit {
    url = "https://git.launchpad.net/lifeograph";
    rev = "v${version}";
    sha256 = "sha256-RotbTdTtpwXmo+UKOyp93IAC6CCstv++KtnX2doN+nM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    shared-mime-info # for update-mime-database
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
