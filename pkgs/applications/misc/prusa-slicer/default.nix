{
  stdenv,
  lib,
  binutils,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost186,
  cereal,
  cgal_5,
  curl,
  dbus,
  eigen,
  expat,
  glew,
  glib,
  glib-networking,
  gmp,
  gtk3,
  hicolor-icon-theme,
  ilmbase,
  libpng,
  mpfr,
  nanosvg,
  nlopt,
  nlohmann_json,
  opencascade-occt_7_6_1,
  openvdb,
  qhull,
  onetbb,
  wxGTK32,
  xorg,
  libbgcode,
  heatshrink,
  catch2_3,
  webkitgtk_4_1,
  ctestCheckHook,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  udevCheckHook,
  z3,
  nix-update-script,
  wxGTK-override ? null,
  opencascade-override ? null,
}:
let
  nanosvg-fltk = nanosvg.overrideAttrs (old: {
    pname = "nanosvg-fltk";
    version = "unstable-2022-12-22";

    src = fetchFromGitHub {
      owner = "fltk";
      repo = "nanosvg";
      rev = "abcd277ea45e9098bed752cf9c6875b533c0892f";
      hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
    };
  });
  wxGTK-override' = if wxGTK-override == null then wxGTK32 else wxGTK-override;
  opencascade-override' =
    if opencascade-override == null then opencascade-occt_7_6_1 else opencascade-override;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prusa-slicer";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    hash = "sha256-1ilgr9RaIoWvj0TDVc20XjjUUcNtnicR7KlE0ii3GQE=";
    rev = "version_${finalAttrs.version}";
  };

  # only applies to prusa slicer because super-slicer overrides *all* patches
  patches = [
    # https://github.com/NixOS/nixpkgs/issues/415703
    # https://gitlab.archlinux.org/archlinux/packaging/packages/prusa-slicer/-/merge_requests/5
    ./allow_wayland.patch
  ];

  # (not applicable to super-slicer fork)
  postPatch = lib.optionalString (finalAttrs.pname == "prusa-slicer") (
    # Patch required for GCC 14, but breaks on clang
    lib.optionalString stdenv.cc.isGNU ''
      substituteInPlace src/slic3r-arrange/include/arrange/DataStoreTraits.hpp \
        --replace-fail \
        "WritableDataStoreTraits<ArrItem>::template set" \
        "WritableDataStoreTraits<ArrItem>::set"
    ''
    # Make Gcode viewer open newer bgcode files.
    + ''
      substituteInPlace src/platform/unix/PrusaGcodeviewer.desktop \
        --replace-fail 'MimeType=text/x.gcode;' 'MimeType=application/x-bgcode;text/x.gcode;'
    ''
  );

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    wxGTK-override'
    udevCheckHook
  ];

  buildInputs = [
    binutils
    boost186 # does not build with 1.87, see https://github.com/prusa3d/PrusaSlicer/issues/13799
    cereal
    cgal_5
    curl
    dbus
    eigen
    expat
    glew
    glib
    glib-networking
    gmp
    gtk3
    hicolor-icon-theme
    ilmbase
    libpng
    mpfr
    nanosvg-fltk
    nlopt
    opencascade-override'
    openvdb
    qhull
    onetbb
    wxGTK-override'
    xorg.libX11
    libbgcode
    heatshrink
    catch2_3
    webkitgtk_4_1
    z3
    nlohmann_json
  ]
  ++ lib.optionals withSystemd [
    systemd
  ];

  strictDeps = true;

  separateDebugInfo = true;

  doInstallCheck = true;

  # The build system uses custom logic - defined in
  # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
  # library, which doesn't pick up the package in the nix store.  We
  # additionally need to set the path via the NLOPT environment variable.
  NLOPT = nlopt;

  # prusa-slicer uses dlopen on `libudev.so` at runtime
  NIX_LDFLAGS = lib.optionalString withSystemd "-ludev";

  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake

    # Disable slic3r_jobs_tests.cpp as the test fails sometimes
    sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt

    # prusa-slicer expects the OCCTWrapper shared library in the same folder as
    # the executable when loading STEP files. We force the loader to find it in
    # the usual locations (i.e. LD_LIBRARY_PATH) instead. See the manpage
    # dlopen(3) for context.
    if [ -f "src/libslic3r/Format/STEP.cpp" ]; then
      substituteInPlace src/libslic3r/Format/STEP.cpp \
        --replace-fail 'libpath /= "OCCTWrapper.so";' 'libpath = "OCCTWrapper.so";'
    fi
    # https://github.com/prusa3d/PrusaSlicer/issues/9581
    if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
      rm cmake/modules/FindEXPAT.cmake
    fi

    # Fix resources folder location on macOS
    substituteInPlace src/${
      if finalAttrs.pname == "prusa-slicer" then "CLI/Setup.cpp" else "PrusaSlicer.cpp"
    } \
      --replace-fail "#ifdef __APPLE__" "#if 0"
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
    # there is many different min versions set accross different
    # Find*.cmake files, substituting them all is not viable
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  postInstall = ''
    ln -s "$out/bin/prusa-slicer" "$out/bin/prusa-gcodeviewer"

    mkdir -p "$out/lib"
    mv -v $out/bin/*.* $out/lib/

    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer.png" "$out/share/pixmaps/PrusaSlicer.png"
    ln -s "$out/share/PrusaSlicer/icons/PrusaSlicer-gcodeviewer_192px.png" "$out/share/pixmaps/PrusaSlicer-gcodeviewer.png"

    mkdir -p "$out"/share/mime/packages
    cat << EOF > "$out"/share/mime/packages/prusa-gcode-viewer.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="application/x-bgcode">
        <comment xml:lang="en">Binary G-code file</comment>
        <glob pattern="*.bgcode"/>
      </mime-type>
    </mime-info>
    EOF
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"
    )
  '';

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  checkFlags = [
    "--force-new-ctest-process"
    "-E"
    "libslic3r_tests|sla_print_tests"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^version_(.+)$"
    ];
  };

  meta = {
    description = "G-code generator for 3D printer";
    homepage = "https://github.com/prusa3d/PrusaSlicer";
    changelog = "https://github.com/prusa3d/PrusaSlicer/releases/tag/version_${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      tweber
      tmarkus
      fliegendewurst
    ];
    platforms = lib.platforms.unix;
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    mainProgram = "PrusaSlicer";
  };
})
