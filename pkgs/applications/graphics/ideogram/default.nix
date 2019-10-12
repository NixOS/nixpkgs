{ stdenv
, fetchFromGitHub
, fetchpatch
, vala
, pkgconfig
, python3
, glib
, gtk3
, meson
, ninja
, libgee
, pantheon
, desktop-file-utils
, xorg
, hicolor-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ideogram";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = pname;
    rev = version;
    sha256 = "1qakgg3y4n2vcnykk2004ndvwmjbk2yy0p4j30mlb7p14dxscif6";
  };

  nativeBuildInputs = [
    desktop-file-utils
    hicolor-icon-theme # for setup-hook
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
    xorg.libX11
    xorg.libXtst
  ];

  patches = [
    # See: https://github.com/cassidyjames/ideogram/issues/26
    (fetchpatch {
      url = "https://github.com/cassidyjames/ideogram/commit/65994ee11bd21f8316b057cec01afbf50639a708.patch";
      sha256 = "12vrvvggpqq53dmhbm7gbbbigncn19m1fjln9wxaady21m0w776c";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Insert emoji anywhere, even in non-native apps - designed for elementary OS";
    homepage = https://github.com/cassidyjames/ideogram;
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };

}
