{ lib
, stdenv
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
      # https://github.com/igraph/igraph/issues/1694
      substituteInPlace tests/CMakeLists.txt \
        --replace "igraph_scg_grouping3" "" \
        --replace "igraph_scg_semiprojectors2" ""
    '';
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
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    rev = "v${version}";
    sha256 = "sha256-uNpELHhSAVRJL/4iypvnl3nX45SqB419r37lthd2WmQ=";
  };

  patches = [
    (fetchpatch {
      # Fix build with python 3.10
      # https://github.com/emsec/hal/pull/463
      name = "hal-fix-python-3.10.patch";
      url = "https://github.com/emsec/hal/commit/f695f55cb2209676ef76366185b7c419417fbbc9.patch";
      sha256 = "sha256-HsCdG3tPllUsLw6kQtGaaEGkEHqZPSC2v9k6ycO2I/8=";
      includes = [ "plugins/gui/src/python/python_context.cpp" ];
    })
  ];

  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    shopt -s extglob
    rm -rf deps/!(sanitizers-cmake)/*
    shopt -u extglob
  '';

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ qtbase qtsvg boost rapidjson igraph' spdlog' graphviz wrapQtAppsHook z3 ]
    ++ (with python3Packages; [ python pybind11 ])
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

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
    "-DBUILD_ALL_PLUGINS=on"
  ];
  # needed for macos build - this is why we use wrapQtAppsHook instead of
  # the qt mkDerivation - the latter forcibly overrides this.
  cmakeBuildType = "MinSizeRel";

  meta = with lib; {
    description = "A comprehensive reverse engineering and manipulation framework for gate-level netlists";
    homepage = "https://github.com/emsec/hal";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris shamilton ];
  };
}
