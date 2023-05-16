{ lib
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gitUpdater
, python3Packages
, blueprint-compiler
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, librsvg
, gtk4
, gtksourceview5
, libadwaita
, cabextract
, p7zip
, xdpyinfo
, imagemagick
, lsb-release
, pciutils
, procps
, gamescope
, mangohud
, vkbasalt-cli
, vmtouch
}:

python3Packages.buildPythonApplication rec {
  pname = "bottles-unwrapped";
<<<<<<< HEAD
  version = "51.9";
=======
  version = "51.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = "bottles";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-iZUszwVcbVn6Xsqou6crSp9gJBRmm5vEqxS87h/s3PQ=";
=======
    sha256 = "sha256-8VF/CD0Wu2eV6wOpj/M6peKDthFWlcg+1NzzTSIH4S8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./vulkan_icd.patch
<<<<<<< HEAD
=======

    # Remove next version
    (fetchpatch {
      url = "https://github.com/bottlesdevs/Bottles/commit/7cb284f9bac0b71bf632bfc70d94f7a53bc51267.patch";
      hash = "sha256-mRF+BtQ0qM7Yvx7SONeH2wc04F87fEyNRlBuyQrzN8Y=";
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # https://github.com/bottlesdevs/Bottles/wiki/Packaging
  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gtk4 # gtk4-update-icon-cache
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    librsvg
    gtk4
    gtksourceview5
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pathvalidate
    pycurl
    pyyaml
    requests
    pygobject3
    patool
    markdown
    fvs
    pefile
    urllib3
    chardet
    certifi
    idna
    orjson
    icoextract
  ] ++ [
    cabextract
    p7zip
    xdpyinfo
    imagemagick
    vkbasalt-cli

    gamescope
    mangohud
    vmtouch

    # Undocumented (subprocess.Popen())
    lsb-release
    pciutils
    procps
  ];

  format = "other";
  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "An easy-to-use wineprefix manager";
    homepage = "https://usebottles.com/";
    downloadPage = "https://github.com/bottlesdevs/Bottles/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ psydvl shamilton ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "bottles";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
