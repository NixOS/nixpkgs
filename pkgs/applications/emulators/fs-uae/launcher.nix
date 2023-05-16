{ lib
, stdenv
, fetchurl
, gettext
, python3
, wrapQtAppsHook
, fsuae
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher";
  version = "3.1.68";

  src = fetchurl {
    url = "https://fs-uae.net/files/FS-UAE-Launcher/Stable/${finalAttrs.version}/fs-uae-launcher-${finalAttrs.version}.tar.xz";
    hash = "sha256-42EERC2yeODx0HPbwr4vmpN80z6WSWi3WzJMOT+OwDA=";
=======
stdenv.mkDerivation rec {
  pname = "fs-uae-launcher";
  version = "3.0.5";

  src = fetchurl {
    url = "https://fs-uae.net/stable/${version}/${pname}-${version}.tar.gz";
    sha256 = "1dknra4ngz7bpppwqghmza1q68pn1yaw54p9ba0f42zwp427ly97";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    wrapQtApp "$out/bin/fs-uae-launcher" \
      --set PYTHONPATH "$PYTHONPATH"

    # fs-uae-launcher search side by side for fs-uae
    # see $src/fsgs/plugins/pluginexecutablefinder.py#find_executable
    ln -s ${fsuae}/bin/fs-uae $out/bin
  '';

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sander AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
})
=======
      wrapQtApp "$out/bin/fs-uae-launcher" --set PYTHONPATH "$PYTHONPATH" \
        --prefix PATH : ${lib.makeBinPath [ fsuae ]}
  '';

  meta = with lib; {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = licenses.gpl2Plus;
    maintainers = with  maintainers; [ sander AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

