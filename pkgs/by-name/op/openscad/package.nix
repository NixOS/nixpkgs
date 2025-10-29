{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
  bison,
  flex,
  eigen,
  boost,
  libGLU,
  libGL,
  glew,
  opencsg,
  cgal_5,
  mpfr,
  gmp,
  glib,
  pkg-config,
  harfbuzz,
  gettext,
  freetype,
  fontconfig,
  double-conversion,
  lib3mf,
  libzip,
  spacenavSupport ? stdenv.hostPlatform.isLinux,
  libspnav,
  wayland,
  wayland-protocols,
  wrapGAppsHook3,
  cairo,
  openscad,
  runCommand,
}:

stdenv.mkDerivation rec {
  pname = "openscad";
  version = "2021.01";

  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "${pname}-${version}";
    sha256 = "sha256-2tOLqpFt5klFPxHNONnHVzBKEFWn4+ufx/MU+eYbliA=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-0496.patch";
      url = "https://github.com/openscad/openscad/commit/00a4692989c4e2f191525f73f24ad8727bacdf41.patch";
      sha256 = "sha256-q3SLj2b5aM/IQ8vIDj4iVcwCajgyJ5juNV/KN35uxfI=";
    })
    (fetchpatch {
      name = "CVE-2022-0497.patch";
      url = "https://github.com/openscad/openscad/commit/84addf3c1efbd51d8ff424b7da276400bbfa1a4b.patch";
      sha256 = "sha256-KNEVu10E2d4G2x+FJcuHo2tjD8ygMRuhUcW9NbN98bM=";
    })
    (fetchpatch {
      # needed for cgal_5
      name = "cgalutils-tess.cc-cgal-5.patch";
      url = "https://github.com/openscad/openscad/commit/3a81c1fb9b663ebbedd6eb044e7276357b1f30a1.patch";
      hash = "sha256-JdBznXkewx5ybY92Ss0h7UnMZ7d3IQbFRaDCDjb1bRA=";
    })
    (fetchpatch {
      # needed for cgal_5
      name = "cgalutils-tess.cc-cgal-5_4.patch";
      url = "https://github.com/openscad/openscad/commit/71f2831c0484c3f35cbf44e1d1dc2c857384100b.patch";
      hash = "sha256-Fu8dnjNIwZKCI6ukOeHYK8NiJwoA0XtqT8dg8sVevG8=";
    })
    (fetchpatch {
      # needed for cgal_5. Removes dead code
      name = "cgalutils-polyhedron.cc-cgal-5_3.patch";
      url = "https://github.com/openscad/openscad/commit/cc49ad8dac24309f5452d5dea9abd406615a52d9.patch";
      hash = "sha256-B3i+o6lR5osRcVXTimDZUFQmm12JhmbFgG9UwOPebF4=";
    })
    (fetchpatch {
      name = "fix-application-icon-not-shown-on-wayland.patch";
      url = "https://github.com/openscad/openscad/commit/5ea83e5117f5f3ac2197c63db69f523721b8fa85.patch";
      hash = "sha256-nfeUv0R+J95fyqnVC0HNeBVZnxVoisY1pcdII82qUSU=";

      # upstream's formatting conventions changed between 2021 and this patch
      postFetch = ''
        sed -i 's/& / \&/g;s/\*\*/\0 /g;s/^\(.\)  /\1\t/' "$out"
      '';
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # ref. https://github.com/openscad/openscad/pull/4013 merged upstream
    (fetchpatch {
      name = "mem_fun-to-mem_fn.patch";
      url = "https://github.com/openscad/openscad/commit/c9a1abbedfbf6dda9a23d3ad5844d11e5278a928.patch";
      hash = "sha256-Man9ledRREb7U+2UOQ0VkpiwbYQjyVOY21YaRFObZc8=";
    })

  ];

  postPatch = ''
    substituteInPlace src/FileModule.cc \
      --replace-fail 'fs::is_regular' 'fs::is_regular_file'

    substituteInPlace src/openscad.cc \
      --replace-fail 'boost::join' 'boost::algorithm::join'
  ''
  # ref. https://github.com/openscad/openscad/pull/4253 merged upstream but does not apply
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/FreetypeRenderer.h \
      --replace-fail ": public std::unary_function<const GlyphData *, void>" ""
  '';

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    gettext
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    eigen
    boost
    glew
    opencsg
    cgal_5
    mpfr
    gmp
    glib
    harfbuzz
    lib3mf
    libzip
    double-conversion
    freetype
    fontconfig
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qscintilla
    cairo
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
    wayland
    wayland-protocols
    libsForQt5.qtwayland
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libsForQt5.qtmacextras
  ++ lib.optional spacenavSupport libspnav;

  qmakeFlags = [
    "VERSION=${version}"
    "LIB3MF_INCLUDEPATH=${lib3mf.dev}/include/lib3mf/Bindings/Cpp"
    "LIB3MF_LIBPATH=${lib3mf}/lib"
  ]
  ++ lib.optionals spacenavSupport [
    "ENABLE_SPNAV=1"
    "SPNAV_INCLUDEPATH=${libspnav}/include"
    "SPNAV_LIBPATH=${libspnav}/lib"
  ];

  enableParallelBuilding = true;

  preBuild = ''
    make objects/parser.cxx
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/*.app $out/Applications
    rmdir $out/bin || true

    mv --target-directory=$out/Applications/OpenSCAD.app/Contents/Resources \
      $out/share/openscad/{examples,color-schemes,locale,libraries,fonts,templates}

    rmdir $out/share/openscad
  '';

  meta = {
    description = "3D parametric model compiler";
    longDescription = ''
      OpenSCAD is a software for creating solid 3D CAD objects. It is free
      software and available for Linux/UNIX, MS Windows and macOS.

      Unlike most free software for creating 3D models (such as the famous
      application Blender) it does not focus on the artistic aspects of 3D
      modelling but instead on the CAD aspects. Thus it might be the
      application you are looking for when you are planning to create 3D models of
      machine parts but pretty sure is not what you are looking for when you are more
      interested in creating computer-animated movies.
    '';
    homepage = "https://openscad.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      raskin
    ];
    mainProgram = "openscad";
  };

  passthru.tests = {
    lib3mf_support =
      runCommand "${pname}-lib3mf-support-test"
        {
          nativeBuildInputs = [ openscad ];
        }
        ''
          echo "cube([1, 1, 1]);" | openscad -o cube.3mf -
          echo "import(\"cube.3mf\");" | openscad -o cube-import.3mf -
          mv cube-import.3mf $out
        '';
  };
}
