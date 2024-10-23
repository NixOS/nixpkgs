{ lib
, stdenv
, fetchFromGitHub
, callPackage
, boost
, cmake
, doxygen
, icu
, p7zip
, pkg-config
, python3Packages
, rustPlatform
, sphinx
, tbb_2021_11
}:

let

  # The CMakeLists.txt uses ExternalProject_Add to fetch dependencies during
  # build. If the tarballs exist in the right location, the pre-fetching is
  # avoided, see GTest, testing-plugins, spdlog, yaml-cpp, and libloot's postPatch.
  # The Rust dependencies are patched out and built with rustPlatform.buildRustPackage
  # and the static libraries are later passed through cmakeFlags, see esplugin,
  # libloadorder, and loot-condition-interpreter.

  GTest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v1.14.0";
    hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
  };

  testing-plugins = callPackage ./testing-plugins.nix { };

  # TODO use pkgs.spdlog
  # It currently fails because ${pkgs.spdlog.dev}/include/spdlog/fmt/bundled/* is missing.
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v1.14.1";
    hash = "sha256-F7khXbMilbh5b+eKnzcB0fPPWQqUHqAYPWJb83OnUKQ=";
  };

  yaml-cpp = fetchFromGitHub {
    owner = "loot";
    repo = "yaml-cpp";
    rev = "0.8.0+merge-key-support.2";
    hash = "sha256-whYorebrLiDeO75LC2SMUX/8OD528BR0+DEgnJxxpoQ=";
  };

  esplugin = callPackage ./esplugin { };

  libloadorder = callPackage ./libloadorder { };

  loot-condition-interpreter = callPackage ./loot-condition-interpreter { };

in

stdenv.mkDerivation rec {
  pname = "libloot";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-k+YO/jqtdXgwIg0bPXQ7tKAdaiJORZbyHcQgBX/5KAY=";
  };

  patches = [ ./remove-external-projects.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    # static Rust libraries
    esplugin
    libloadorder
    loot-condition-interpreter
    # documentation
    doxygen
    python3Packages.breathe
    python3Packages.sphinx-rtd-theme
    sphinx
  ];

  buildInputs = [
    boost
    icu
    tbb_2021_11
  ];

  cmakeFlags = [
    "-DESPLUGIN_LIBRARIES=${esplugin}/lib/libesplugin_ffi.a"
    "-DLIBLOADORDER_LIBRARIES=${libloadorder}/lib/libloadorder_ffi.a"
    "-DLCI_LIBRARIES=${loot-condition-interpreter}/lib/libloot_condition_interpreter_ffi.a"
    "-DFETCHCONTENT_SOURCE_DIR_GTEST=${GTest}"
    "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog}"
    # testing-plugins must be writable so we copy and add it to cmakeFlags in preConfigure
    "-DFETCHCONTENT_SOURCE_DIR_YAML-CPP=${yaml-cpp}"
  ];

  preConfigure = ''
    tmp=$(mktemp -d)
    cp -r ${testing-plugins} "$tmp/testing-plugins"
    chmod -R u+w "$tmp/testing-plugins"
    cmakeFlags="$cmakeFlags -DFETCHCONTENT_SOURCE_DIR_TESTING-PLUGINS=$tmp/testing-plugins"
  '';

  postBuild = ''
    (cd .. && sphinx-build -b html docs build/docs/html)
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./libloot_internals_tests --gtest_filter=${
      lib.escapeShellArg "-${
        lib.concatStringsSep ":" [
          # locale::facet::_S_create_c_locale name not valid
          "CompareFilenames.shouldBeCaseInsensitiveAndLocaleInvariant"
          "NormalizeFilename.shouldCaseFoldStringsAndBeLocaleInvariant"
          # No such file or directory
          "Filesystem.equivalentShouldNotRequireThatBothPathsExist"
          "Filesystem.equivalentShouldBeCaseSensitive"
        ]
      }"
    }
    ./libloot_tests

    runHook postCheck
  '';

  outputs = [ "out" "dev" "doc" ];

  passthru = { inherit esplugin libloadorder loot-condition-interpreter; };

  meta = with lib; {
    homepage = "https://github.com/loot/libloot";
    description = "A C++ library for accessing LOOT's metadata and sorting functionality";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
