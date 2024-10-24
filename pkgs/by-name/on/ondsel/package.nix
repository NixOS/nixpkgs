{
  lib,
  cmake,
  fetchFromGitHub,
  freecad,
  gfortran,
  makeDesktopItem,
  ninja,
  pkg-config,
  yaml-cpp,
}:
freecad.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "ondsel";
    version = "2024.2.2";

    src = fetchFromGitHub {
      owner = "Ondsel-Development";
      repo = "FreeCAD";
      rev = finalAttrs.version;
      hash = "sha256-mruDZnh00UPUEGNPDQ0/agJVOunKi57mECwJmqVFo1M=";
      fetchSubmodules = true;
    };
    feedstock = fetchFromGitHub {
      owner = "Ondsel-Development";
      repo = "ondsel-es-feedstock";
      rev = "386fab80c8aaa3bb1b9454aee8695c959d642bac";
      hash = "sha256-H5LbcK5iXS+QFhMayvCDSfXk2ulc6BJXWVwv97nPH9o=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      cmake
      ninja
      pkg-config
      gfortran
      yaml-cpp
    ];

    patches = [
      ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
    ];

    cmakeFlags = previousAttrs.cmakeFlags ++ [ "-DINSTALL_TO_SITEPACKAGES=OFF" ];

    postPatch = ''
      substituteInPlace src/3rdParty/OndselSolver/OndselSolver.pc.in \
        --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
        --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
    '';

    postFixup = ''
      cp $feedstock/recipe/branding/branding.xml $out/bin
      cp -r $feedstock/recipe/branding $out/share/Gui/Ondsel

      mv $out/share/doc $out
      mv $out/bin/FreeCAD $out/bin/Ondsel
      mv $out/bin/FreeCADCmd $out/bin/OndselCmd
      ln -s $out/bin/Ondsel $out/bin/ondsel
      ln -s $out/bin/OndselCmd $out/bin/ondcelcmd
    '';

    meta = with lib; {
      # mainProgram = "freecad";
      homepage = "https://ondsel.com/";
      description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler (Fork of FreeCAD)";
      license = lib.licenses.lgpl2Plus;
      maintainers = with lib.maintainers; [
        shved
        pinpox
      ];
      platforms = platforms.linux;
    };
  }
)
