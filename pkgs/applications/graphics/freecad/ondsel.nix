{ lib
, cmake
, fetchFromGitHub
, freecad
, gfortran
, makeDesktopItem
, ninja
, pkg-config
, yaml-cpp
}:
let
  ondsel = freecad.overrideAttrs (finalAttrs: previousAttrs: {

    pname = "ondsel";
    version = "2024.1.0";

    src = fetchFromGitHub {
      owner = "Ondsel-Development";
      repo = "FreeCAD";
      rev = finalAttrs.version;
      hash = "sha256-1Xyj2ta9ukBzP/Be0qivm0nv4/s4GGPwV+O3Ukd/5mE=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      cmake
      ninja
      pkg-config
      gfortran
      yaml-cpp
    ];

    postPatch = ''
      substituteInPlace src/3rdParty/OndselSolver/OndselSolver.pc.in \
        --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
        --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
    '';

    postFixup =
      let
        feedstock = fetchFromGitHub {
          owner = "Ondsel-Development";
          repo = "freecad-feedstock";
          rev = "386fab80c8aaa3bb1b9454aee8695c959d642bac";
          hash = "sha256-H5LbcK5iXS+QFhMayvCDSfXk2ulc6BJXWVwv97nPH9o=";
          fetchSubmodules = true;
        };
      in
      ''
        cp ${feedstock}/recipe/branding/branding.xml $out/bin
        cp -r ${feedstock}/recipe/branding $out/share/Gui/Ondsel

        mv $out/share/doc $out
        ln -s $out/bin/FreeCAD $out/bin/freecad
        ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
      '';

    meta = with lib; {
      # mainProgram = "freecad";
      homepage = "https://ondsel.com/";
      description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler (Fork of FreeCAD)";
      license = lib.licenses.lgpl2Plus;
      maintainers = with lib.maintainers; [ viric gebner AndersonTorres pinpox ];
      platforms = platforms.linux;
    };
  });
in
ondsel
