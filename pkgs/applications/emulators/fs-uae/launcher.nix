{ lib
, stdenv
, fetchurl
, gettext
, python3
, wrapQtAppsHook
, fsuae
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher";
  version = "3.1.70";

  src = fetchurl {
    url = "https://fs-uae.net/files/FS-UAE-Launcher/Stable/${finalAttrs.version}/fs-uae-launcher-${finalAttrs.version}.tar.xz";
    hash = "sha256-yvJ8sa44V13SEUJ6C9SgS+N2ZFH5+20TTL2ICY9A36c=";
  };

  nativeBuildInputs = [
    gettext
    python3
    wrapQtAppsHook
  ];

  buildInputs = with python3.pkgs; [
    pyqt5
    requests
    setuptools
  ];

  makeFlags = [ "prefix=$(out)" ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/fs-uae-launcher" \
      --set PYTHONPATH "$PYTHONPATH"

    # fs-uae-launcher search side by side for executables and shared files
    # see $src/fsgs/plugins/pluginexecutablefinder.py#find_executable
    ln -s ${fsuae}/bin/fs-uae $out/bin
    ln -s ${fsuae}/bin/fs-uae-device-helper $out/bin
    ln -s ${fsuae}/share/fs-uae $out/share/fs-uae
  '';

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sander AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
})

