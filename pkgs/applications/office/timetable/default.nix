{ stdenv
, fetchFromGitHub
, glib
, gtk3
, vala
, json-glib
, libgee
, meson
, ninja
, pkgconfig
, pantheon
, python3
, wrapGAppsHook
}:


stdenv.mkDerivation rec {
  pname = "timetable";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1n02y7vpi4lb888iic06xifc86n2xirk50s1ssf84vlc5md1kq9f";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libgee
    pantheon.granite
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
    description = "Plot out your own timetable for the week and organize it";
    homepage = "https://github.com/lainsce/timetable";
    maintainers = [ maintainers.kjuvi ] ++ pantheon.maintainers;
    license = licenses.gpl2Plus;
  };
}
