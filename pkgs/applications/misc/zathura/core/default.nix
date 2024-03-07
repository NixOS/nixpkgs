{ lib, stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkg-config
, appstream-glib, json-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2, check
, sqlite, glib, texlive, libintl, libseccomp
, file, librsvg
, gtk-mac-integration
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura";
  version = "0.5.4";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${finalAttrs.version}.tar.xz";
    sha256 = "0ckgamf98sydq543arp865jg1afwzhpzcsbhv6zrch2dm5x7y0x3";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  # Flag list:
  # https://github.com/pwmt/zathura/blob/master/meson_options.txt
  mesonFlags = [
    "-Dsqlite=enabled"
    "-Dmanpages=enabled"
    "-Dconvert-icon=enabled"
    "-Dsynctex=enabled"
    "-Dtests=disabled"
    # Make sure tests are enabled for doCheck
    # (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonEnable "seccomp" stdenv.hostPlatform.isLinux)
  ];

  nativeBuildInputs = [
    meson ninja pkg-config desktop-file-utils python3.pythonOnBuildForHost.pkgs.sphinx
    gettext wrapGAppsHook libxml2 appstream-glib
  ];

  buildInputs = [
    gtk girara libintl sqlite glib file librsvg check json-glib
    texlive.bin.core
  ] ++ lib.optional stdenv.isLinux libseccomp
    ++ lib.optional stdenv.isDarwin gtk-mac-integration;

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://git.pwmt.org/pwmt/zathura";
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
})
