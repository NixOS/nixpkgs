{ lib
, fetchFromGitHub
, fetchFromGitLab
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
, steam
, cabextract
, p7zip
, xdpyinfo
, imagemagick
, procps
, gamescope
, mangohud
, vmtouch
, wine
, bottlesExtraLibraries ? pkgs: [ ] # extra packages to add to steam.run multiPkgs
, bottlesExtraPkgs ? pkgs: [ ] # extra packages to add to steam.run targetPkgs
}:

let
  steam-run = (steam.override {
    # required by wine runner `caffe`
    extraLibraries = pkgs: with pkgs; [ libunwind libusb1 gnutls ]
      ++ bottlesExtraLibraries pkgs;
    extraPkgs = pkgs: [ ]
      ++ bottlesExtraPkgs pkgs;
  }).run;
in
python3Packages.buildPythonApplication rec {
  pname = "bottles";
  version = "2022.10.14.1";

  src = fetchFromGitHub {
    owner = "bottlesdevs";
    repo = pname;
    rev = version;
    sha256 = "sha256-FO91GSGlc2f3TSLrlmRDPi5p933/Y16tdEpX4RcKhL0=";
  };

  patches = [ ./vulkan_icd.patch ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py

    substituteInPlace bottles/backend/wine/winecommand.py \
      --replace \
        "command = f\"{runner} {command}\"" \
        "command = f\"{''' if runner == 'wine' or runner == 'wine64' else '${steam-run}/bin/steam-run '}{runner} {command}\"" \
      --replace \
        "command = f\"{_picked['entry_point']} {command}\"" \
        "command = f\"${steam-run}/bin/steam-run {_picked['entry_point']} {command}\""
    '';

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
    pillow
    orjson
    icoextract
  ] ++ [
    cabextract
    p7zip
    xdpyinfo
    imagemagick
    procps

    gamescope
    mangohud
    vmtouch
    wine
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
  };
}
