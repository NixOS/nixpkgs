{ stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, pkgconfig
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "appeditor";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "donadigo";
    repo = "appeditor";
    rev = version;
    sha256 = "04x2f4x4dp5ca2y3qllqjgirbyl6383pfl4bi9bkcqlg8b5081rg";
  };

  nativeBuildInputs = [
    gettext
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
    pantheon.granite
    libgee
  ];

  patches = [
    # See: https://github.com/donadigo/appeditor/issues/88
    ./fix-build-vala-0.46.patch
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
    description = "Edit the Pantheon desktop application menu";
    homepage = https://github.com/donadigo/appeditor;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
