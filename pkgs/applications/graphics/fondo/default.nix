{ stdenv
, fetchFromGitHub
, fetchpatch
, pantheon
, vala
, pkgconfig
, meson
, ninja
, python3
, glib
, gsettings-desktop-schemas
, gtk3
, libgee
, json-glib
, glib-networking
, libsoup
, libunity
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fondo";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "calo001";
    repo = pname;
    rev = version;
    sha256 = "0w7qai261l9m7ckzxc2gj3ywa55wm6p5br1xdk7607ql44lfpgba";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    json-glib
    libgee
    libsoup
    libunity
    pantheon.granite
  ];

  patches = [
    # Fix hardcoded FHS gsettings path
    (fetchpatch {
      url = "https://github.com/calo001/fondo/commit/98afdd834201321a3242f0b53bfba4b2ffa04a4c.patch";
      sha256 = "0vvgbgjja6vyrk6in3sgv8jbl4bwxkm6fhllgjzq7r65gkj4jg79";
    })
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
    description = "Find the most beautiful wallpapers for your desktop";
    homepage = https://github.com/calo001/fondo;
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
