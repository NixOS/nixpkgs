{ lib
, stdenv
<<<<<<< HEAD
, boost
, cmake
, fetchFromGitHub
, fetchpatch
, graphviz
, igraph
, llvmPackages
, ninja
, pkg-config
, python3Packages
, qtbase
, qtsvg
, quazip
, rapidjson
, spdlog
, suitesparse
, wrapQtAppsHook
, z3
}:

let
  # hal doesn't work with igraph 0.10.x yet https://github.com/emsec/hal/pull/487
  igraph' = igraph.overrideAttrs (final: prev: {
    version = "0.9.10";
    src = fetchFromGitHub {
      owner = "igraph";
      repo = final.pname;
      rev = final.version;
      hash = "sha256-prDadHsNhDRkNp1i0niKIYxE0g85Zs0ngvUy6uK8evk=";
    };
    patches = (prev.patches or []) ++ [
      # needed by clang
      (fetchpatch {
        name = "libxml2-2.11-compat.patch";
        url = "https://github.com/igraph/igraph/commit/5ad464be5ae2f6ebb69c97cb0140c800cc8d97d6.patch";
        hash = "sha256-adU5SctH+H54UaAmr5BZInytD3wjUzLtQbCwngAWs4o=";
      })
    ];
    postPatch = prev.postPatch + lib.optionalString stdenv.isAarch64 ''
=======
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, pkg-config
, python3Packages
, boost
, rapidjson
, qtbase
, qtsvg
, igraph
, spdlog
, wrapQtAppsHook
, graphviz
, llvmPackages
, z3
, fmt_8
, suitesparse
}:

let
  igraph' = igraph.overrideAttrs (old: rec {
    version = "0.9.10";
    src = fetchFromGitHub {
      owner = "igraph";
      repo = "igraph";
      rev = version;
      hash = "sha256-prDadHsNhDRkNp1i0niKIYxE0g85Zs0ngvUy6uK8evk=";
    };
    postPatch = old.postPatch + lib.optionalString stdenv.isAarch64 ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      # https://github.com/igraph/igraph/issues/1694
      substituteInPlace tests/CMakeLists.txt \
        --replace "igraph_scg_grouping3" "" \
        --replace "igraph_scg_semiprojectors2" ""
    '';
<<<<<<< HEAD
    # general options brought back from the old 0.9.x package
    buildInputs = prev.buildInputs ++ [ suitesparse ];
    cmakeFlags = prev.cmakeFlags ++ [ "-DIGRAPH_USE_INTERNAL_CXSPARSE=OFF" ];
  });

in stdenv.mkDerivation rec {
  version = "4.2.0";
=======
    buildInputs = old.buildInputs ++ [ suitesparse ];
    cmakeFlags = old.cmakeFlags ++ [ "-DIGRAPH_USE_INTERNAL_CXSPARSE=OFF" ];
  });
  # no stable hal release yet with recent spdlog/fmt support, remove
  # once 4.0.0 is released - see https://github.com/emsec/hal/issues/452
  spdlog' = spdlog.override {
    fmt = fmt_8.overrideAttrs (_: rec {
      version = "8.0.1";
      src = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = version;
        sha256 = "1mnvxqsan034d2jiqnw2yvkljl7lwvhakmj5bscwp1fpkn655bbw";
      };
    });
  };
in stdenv.mkDerivation rec {
  version = "3.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Yl86AClE3vWygqj1omCOXX8koJK2SjTkMZFReRThez0=";
=======
    sha256 = "sha256-uNpELHhSAVRJL/4iypvnl3nX45SqB419r37lthd2WmQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (fetchpatch {
<<<<<<< HEAD
      name = "cmake-add-no-vendored-options.patch";
      # https://github.com/emsec/hal/pull/529
      url = "https://github.com/emsec/hal/commit/37d5c1a0eacb25de57cc552c13e74f559a5aa6e8.patch";
      hash = "sha256-a30VjDt4roJOTntisixqnH17wwCgWc4VWeh1+RgqFuY=";
    })
    (fetchpatch {
      name = "hal-fix-fmt-10.1-compat.patch";
      # https://github.com/emsec/hal/pull/530
      url = "https://github.com/emsec/hal/commit/b639a56b303141afbf6731b70b7cc7452551f024.patch";
      hash = "sha256-a7AyDEKkqdbiHpa4OHTRuP9Yewb3Nxs/j6bwez5m0yU=";
=======
      # Fix build with python 3.10
      # https://github.com/emsec/hal/pull/463
      name = "hal-fix-python-3.10.patch";
      url = "https://github.com/emsec/hal/commit/f695f55cb2209676ef76366185b7c419417fbbc9.patch";
      sha256 = "sha256-HsCdG3tPllUsLw6kQtGaaEGkEHqZPSC2v9k6ycO2I/8=";
      includes = [ "plugins/gui/src/python/python_context.cpp" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    shopt -s extglob
<<<<<<< HEAD
    rm -rf deps/!(abc|sanitizers-cmake|subprocess)/*
    shopt -u extglob
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtsvg
    boost
    rapidjson
    igraph'
    spdlog
    graphviz
    z3
    quazip
  ]
  ++ (with python3Packages; [ python pybind11 ])
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
  ;
=======
    rm -rf deps/!(sanitizers-cmake)/*
    shopt -u extglob
  '';

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ qtbase qtsvg boost rapidjson igraph' spdlog' graphviz wrapQtAppsHook z3 ]
    ++ (with python3Packages; [ python pybind11 ])
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = with lib.versions; [
    "-DHAL_VERSION_RETURN=${version}"
    "-DHAL_VERSION_MAJOR=${major version}"
    "-DHAL_VERSION_MINOR=${minor version}"
    "-DHAL_VERSION_PATCH=${patch version}"
    "-DHAL_VERSION_TWEAK=0"
    "-DHAL_VERSION_ADDITIONAL_COMMITS=0"
    "-DHAL_VERSION_DIRTY=false"
    "-DHAL_VERSION_BROKEN=false"
    "-DENABLE_INSTALL_LDCONFIG=off"
<<<<<<< HEAD
    "-DUSE_VENDORED_PYBIND11=off"
    "-DUSE_VENDORED_SPDLOG=off"
    "-DUSE_VENDORED_QUAZIP=off"
    "-DUSE_VENDORED_IGRAPH=off"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-DBUILD_ALL_PLUGINS=on"
  ];
  # needed for macos build - this is why we use wrapQtAppsHook instead of
  # the qt mkDerivation - the latter forcibly overrides this.
  cmakeBuildType = "MinSizeRel";

<<<<<<< HEAD
  # some plugins depend on other plugins and need to be able to load them
  postFixup = lib.optionalString stdenv.isLinux ''
    find $out/lib/hal_plugins -name '*.so*' | while read -r f ; do
      patchelf --set-rpath "$(patchelf --print-rpath "$f"):$out/lib/hal_plugins" "$f"
    done
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A comprehensive reverse engineering and manipulation framework for gate-level netlists";
    homepage = "https://github.com/emsec/hal";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris shamilton ];
  };
}
