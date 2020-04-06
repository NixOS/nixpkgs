{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, bamf
, libwnck3
, libgee
, libgtop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "monitor";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "stsdc";
    repo = "monitor";
    rev = version;
    sha256 = "0cqzxlzdbij26qgbbngqx6njcpcymkgvm29b7ipldgkssxp1mkkg";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    glib
    gtk3
    pantheon.granite
    pantheon.wingpanel
    libgee
    libgtop
    libwnck3
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
    description = "Manage processes and monitor system resources";
    homepage = "https://github.com/stsdc/monitor";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
