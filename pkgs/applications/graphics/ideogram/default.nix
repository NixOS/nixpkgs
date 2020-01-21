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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ideogram";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = pname;
    rev = version;
    sha256 = "0ghc7hk4b4r3a0x9r30rrgv3rarxyjr2hf9ig244xwvhh5rn3j10";
  };

  nativeBuildInputs = [
    desktop-file-utils
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

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Insert emoji anywhere, even in non-native apps - designed for elementary OS";
    homepage = https://github.com/cassidyjames/ideogram;
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };

}
