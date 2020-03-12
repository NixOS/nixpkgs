{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, desktop-file-utils
, pantheon
, python3
, glib
, gtk3
, json-glib
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "khronos";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "0s6yx05k0x90bmdmr61hw07nf9a1kyvvk6gwlg8m97zq1n3qc0f3";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
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
    description = "Track each task's time in a simple inobtrusive way";
    homepage = "https://github.com/lainsce/khronos";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
