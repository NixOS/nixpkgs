{
  stdenv,
  lib,
  binutils,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost187,
  c-blosc,
  cereal,
  cgal,
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
  imath,
  libjpeg_turbo,
  libpng,
  mpfr,
  nanosvg,
  nlohmann_json,
  nlopt,
  onetbb,
  opencascade-occt,
  openvdb,
  pcre2,
  python3,
  python3Packages, # pybind11
  qhull,
  wxwidgets_3_2,
  libx11,
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
  wxGTK-override' = if wxGTK-override == null then wxwidgets_3_2 else wxGTK-override;
  opencascade-override' =
    if opencascade-override == null then opencascade-occt else opencascade-override;

in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "preflight";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "oozebot";
    repo = "preFlight";
    hash = "sha256-3m/mz0DwuhIo7E/9V8kL68TO0WjNGIHyFlG9EYtDeMs=";
    tag = "v${finalAttrs.version}";
  };

  patches = [
    # Fix for webkitgtk linking
    ./patches/0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
    # https://github.com/NixOS/nixpkgs/issues/415703
    # https://gitlab.archlinux.org/archlinux/packaging/packages/prusa-slicer/-/merge_requests/5
    ./patches/allow_wayland.patch
  ];

  postPatch = (
    # Make Gcode viewer open newer bgcode files.
    ''
      substituteInPlace src/platform/unix/preFlightGcodeviewer.desktop \
        --replace-fail 'MimeType=text/x.gcode;' 'MimeType=application/x-bgcode;text/x.gcode;'
    ''
    # Make preFlight handle the url "prusaslicer://"
    + ''
      substituteInPlace src/platform/unix/preFlight.desktop \
        --replace-fail \
        'Exec=preflight %F' \
        'Exec=preflight %U'

      substituteInPlace src/platform/unix/preFlight.desktop \
        --replace-fail \
        'MimeType=model/stl;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;' \
        'MimeType=model/stl;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;x-scheme-handler/prusaslicer;'
    ''
  );

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
    wxGTK-override'
    udevCheckHook
  ];

  buildInputs = [
    binutils
    boost187
    c-blosc
    cereal
    cgal
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
    imath
    libjpeg_turbo
    libpng
    mpfr
    nanosvg-fltk
    nlopt
    onetbb
    opencascade-override'
    openvdb
    pcre2
    python3
    python3Packages.pybind11
    qhull
    wxGTK-override'
    libx11
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

  # Causes wrapGAppsHook3 to only wrap the debug output
  separateDebugInfo = false;

  doInstallCheck = true;

  env = {
    # The build system uses custom logic - defined in
    # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
    # library, which doesn't pick up the package in the nix store.  We
    # additionally need to set the path via the NLOPT environment variable.
    NLOPT = nlopt;
  }
  // lib.optionalAttrs withSystemd {
    # prusa-slicer uses dlopen on `libudev.so` at runtime
    NIX_LDFLAGS = "-ludev";
  };

  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake

    # https://github.com/prusa3d/PrusaSlicer/issues/9581
    if [ -f "cmake/modules/FindEXPAT.cmake" ]; then
      rm cmake/modules/FindEXPAT.cmake
    fi

    # Fix resources folder location on macOS
    substituteInPlace src/${
      if finalAttrs.pname == "preflight" then "CLI/Setup.cpp" else "preFlight.cpp"
    } \
      --replace-fail "#ifdef __APPLE__" "#if 0"

    substituteInPlace src/libslic3r/CMakeLists.txt \
      --replace-fail "libjpeg-turbo::jpeg-static" "libjpeg-turbo::jpeg"

    substituteInPlace \
      src/libslic3r/GCode/PostProcessor.cpp \
      src/slic3r/GUI/RemovableDriveManager.cpp \
      src/slic3r/Utils/Process.cpp \
        --replace-fail "<boost/process.hpp>" "<boost/process/v2.hpp>"
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
    # there is many different min versions set accross different
    # Find*.cmake files, substituting them all is not viable
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF"
    "-Wno-dev"
  ];
  NIX_CFLAGS_COMPILE = "-fno-lto";
  NIX_CXXFLAGS_COMPILE = "-fno-lto";

  postInstall = ''
    ln -s "$out/bin/preflight" "$out/bin/preflight-gcodeviewer"

    mkdir -p "$out"/share/mime/packages
    cat << EOF > "$out"/share/mime/packages/preflight-gcode-viewer.xml
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
      "^v(.+)$"
    ];
  };

  meta = {
    description = "G-code generator for 3D printer";
    homepage = "preflight3d.com";
    changelog = "https://github.com/oozebot/preFlight/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
    platforms = lib.platforms.unix;
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    mainProgram = "preFlight";
  };
})
