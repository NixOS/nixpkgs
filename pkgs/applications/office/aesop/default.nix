{ stdenv, vala, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, python3, gtk3
, desktop-file-utils, json-glib, libsoup, libgee, poppler, wrapGAppsHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "aesop";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1hnwhxaz0zx4fswrxjzyv5s77v5fimn87yid9sd1qgfv2g1ck0jc";
  };

  patches = [
    # Fix build
    # https://github.com/lainsce/aesop/pull/33
    (fetchpatch {
      url = "https://github.com/lainsce/aesop/commit/850ec86bbfef5168e537a5af7e0d73d96db56330.patch";
      sha256 = "14b251wp11rypqw4fafwjbsqy92mxzr8mmaxlv7n4whvwxrzqirh";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.elementary-icon-theme
    libgee
    pantheon.granite
    gtk3
    json-glib
    libsoup
    poppler
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
    description = "The simplest PDF viewer around";
    homepage = https://github.com/lainsce/aesop;
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
