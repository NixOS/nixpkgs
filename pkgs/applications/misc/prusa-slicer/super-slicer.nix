{
  stdenv, lib, fetchFromGitHub, makeDesktopItem, prusa-slicer
}:
let
  appname = "SuperSlicer";
  version = "2.2.54.2";
  pname = "super-slicer";
  description = "PrusaSlicer fork with more features and faster development cycle";
  override = super: {
    inherit version pname;

    src = fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      sha256 = "sha256-ThmsxFXI1uReK+JwpHrIWzHpBdIOP77kDjv+QaK+Azk=";
      rev = version;
    };

    # See https://github.com/supermerill/SuperSlicer/issues/432
    cmakeFlags = super.cmakeFlags ++ [
      "-DSLIC3R_BUILD_TESTS=0"
    ];

    postInstall = ''
      mkdir -p "$out/share/pixmaps/"
      ln -s "$out/share/SuperSlicer/icons/Slic3r.png" "$out/share/pixmaps/${appname}.png"
      mkdir -p "$out/share/applications"
      cp "$desktopItem"/share/applications/* "$out/share/applications/"
    '';

    desktopItem = makeDesktopItem {
      name = appname;
      exec = "superslicer";
      icon = appname;
      comment = description;
      desktopName = appname;
      genericName = "3D printer tool";
      categories = "Development;";
    };

    meta = with stdenv.lib; {
      inherit description;
      homepage = "https://github.com/supermerili/SuperSlicer";
      license = licenses.agpl3;
      maintainers = with maintainers; [ cab404 moredread ];
    };

  };
in prusa-slicer.overrideAttrs override
