{ lib
, stdenv
, fetchFromGitHub
, fetchurl
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

  GTest = fetchurl {
    url = "https://github.com/google/googletest/archive/v1.14.0.tar.gz";
    hash = "sha256-itWYxzrXluDYKAsILOvYKmMNc+c808cAV5OKZQG7pdc=";
  };

  testing-plugins = callPackage ./testing-plugins.nix { };

  # TODO use pkgs.spdlog
  # It currently fails because ${pkgs.spdlog.dev}/include/spdlog/fmt/bundled/* is missing.
  spdlog = fetchurl {
    url = "https://github.com/gabime/spdlog/archive/v1.12.0.tar.gz";
    hash = "sha256-Tczy0Q9BDB4v6v+Jlmv8SaGrsp728IJGM1sRDgAeCak=";
  };

  yaml-cpp = fetchurl {
    url = "https://github.com/loot/yaml-cpp/archive/0.8.0+merge-key-support.1.tar.gz";
    hash = "sha256-B+vpNSrsVfGy2FXIdRvvy5gbQtRgIzZSftz9G/rpofw=";
  };

  esplugin = callPackage ./esplugin { };

  libloadorder = callPackage ./libloadorder { };

  loot-condition-interpreter = callPackage ./loot-condition-interpreter { };

in

stdenv.mkDerivation rec {
  pname = "libloot";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "loot";
    repo = pname;
    rev = version;
    hash = "sha256-z+lakQLJF2cBdYjAwtlcth8Z/2Y0KM4gynuBuI2yGOI=";
  };

  patches = [ ./remove-external-projects.patch ];

  # prefetch remaining ExternalProjects
  postPatch = ''
    mkdir -p build/external/src
  '' + lib.concatMapStrings (tarball: ''
    ln -s ${tarball} build/external/src/${baseNameOf tarball.url}
  '') [
    GTest
    testing-plugins
    spdlog
    yaml-cpp
  ];

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
  ];

  # The location of libyaml-cpp.a seems to be wrong:
  #   expected: external/src/yaml-cpp-build/Release/libyaml-cpp.a
  #        got: external/src/yaml-cpp-build/libyaml-cpp.a
  # TODO patch CMakeLists.txt
  preBuild = ''
    ln -s . external/src/yaml-cpp-build/Release
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

  postInstall = ''
    mkdir "$out/lib"
    mv "$out/libloot.so" "$out/lib"

    mkdir "$dev"
    mv "$out/include" "$dev/include"

    mkdir -p "$doc/share/doc"
    mv "$out/docs" "$doc/share/doc/libloot"
  '';

  passthru = { inherit esplugin libloadorder loot-condition-interpreter; };

  meta = with lib; {
    homepage = "https://github.com/loot/libloot";
    description = "A C++ library for accessing LOOT's metadata and sorting functionality";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
