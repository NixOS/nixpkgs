{ lib
, stdenv
, fetchFromGitHub
, fetchurl
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

  testing-plugins = fetchurl {
    url = "https://github.com/Ortham/testing-plugins/archive/1.5.0.tar.gz";
    hash = "sha256-mMkJT7DwFSsa96YgaVAgf33cZgLNRO1n6/cGA+9JB5E=";
  };

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

  esplugin = rustPlatform.buildRustPackage rec {
    pname = "esplugin";
    version = "4.1.0";

    src = fetchFromGitHub {
      owner = "Ortham";
      repo = pname;
      rev = version;
      hash = "sha256-jIqXwEIYBJgKXEwolLIbdzy9arJPte8xklzAWVjBjfo=";
    };

    cargoLock = {
      lockFile = ./esplugin-Cargo.lock;
    };

    postPatch = ''
      ln -s ${cargoLock.lockFile} Cargo.lock
    '';

    # needed to build ffi/include
    cargoBuildFlags = [ "--all" "--all-features" ];

    preCheck = ''
      tmp=$(mktemp -dp .)
      tar -C "$tmp" -xzf ${testing-plugins}
      ln -s "$tmp"/* testing-plugins
    '';

    # libloot expects esplugin.hpp not esplugin.h
    postInstall = ''
      install -Dm 644 ffi/include/esplugin.h $out/include/esplugin.hpp
    '';

    meta = with lib; {
      description = "A free software library for reading Elder Scrolls plugin (.esp/.esm/.esl) files";
      homepage = "https://github.com/Ortham/esplugin";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.schnusch ];
    };
  };

  libloadorder = rustPlatform.buildRustPackage rec {
    pname = "libloadorder";
    version = "15.0.1";

    src = fetchFromGitHub {
      owner = "Ortham";
      repo = pname;
      rev = version;
      hash = "sha256-Cp29h48z0iE3zrcRktDwbIZwx4tVfUzmpkR1pjEmM+w=";
    };

    cargoLock = {
      lockFile = ./libloadorder-Cargo.lock;
    };

    postPatch = ''
      ln -s ${cargoLock.lockFile} Cargo.lock
    '';

    cargoBuildFlags = [ "--all" "--all-features" ];

    preCheck = ''
      tmp=$(mktemp -dp .)
      tar -C "$tmp" -xzf ${testing-plugins}
      ln -s "$tmp"/* testing-plugins
    '';

    # libloot expects libloadorder.hpp not libloadorder.h
    postInstall = ''
      install -Dm 644 ffi/include/libloadorder.h $out/include/libloadorder.hpp
    '';

    meta = with lib; {
      description = "A cross-platform library for manipulating the load order and active status of plugins for the Elder Scrolls and Fallout games";
      homepage = "https://github.com/Ortham/libloadorder";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.schnusch ];
    };
  };

  loot-condition-interpreter = rustPlatform.buildRustPackage rec {
    pname = "loot-condition-interpreter";
    version = "3.1.0";

    src = fetchFromGitHub {
      owner = "loot";
      repo = pname;
      rev = version;
      hash = "sha256-hPDIx/Tc1JsiF0dcsQlrQJRfzLSFQbbUls0Q/dkwVwg=";
    };

    cargoLock = {
      lockFile = ./loot-condition-interpreter-Cargo.lock;
    };

    postPatch = ''
      ln -s ${cargoLock.lockFile} Cargo.lock
    '';

    cargoBuildFlags = [ "--package" "loot-condition-interpreter-ffi" "--all-features" ];

    preCheck = ''
      tmp=$(mktemp -dp .)
      tar -C "$tmp" -xzf ${testing-plugins}
      (cd tests && ln -rs "../$tmp"/* testing-plugins)

      tmp=$(mktemp -dp .)
      ${p7zip}/bin/7z x -o"$tmp" ${fetchurl {
        url = "https://github.com/loot/libloot/releases/download/0.18.2/libloot-0.18.2-0-gb1a9e31_0.18.2-win32.7z";
        hash = "sha256-sy2DvQcyy4Yd6bgFEN/dq2yoNpxMP3A6aT3GZ64yUss=";
      }}
      (cd tests && ln -s "../$tmp"/* libloot_win32)

      tmp=$(mktemp -dp .)
      ${p7zip}/bin/7z x -o"$tmp" ${fetchurl {
        url = "https://github.com/loot/libloot/releases/download/0.18.2/libloot-0.18.2-0-gb1a9e31_0.18.2-win64.7z";
        hash = "sha256-gRkRQ5XmzPPYm3QZQY45CebX5koNWU7eVuB8Ojls3nM=";
      }}
      (cd tests && ln -s "../$tmp"/* libloot_win64)
    '';

    checkFlags = [
      # We don't want to download, extract, and then fix-up another archive
      # for those two tests.
      "--skip=function::version::tests::constructors::version_read_file_version_should_return_none_if_there_is_no_version_info"
      "--skip=function::version::tests::constructors::version_read_product_version_should_return_none_if_there_is_no_version_info"
    ];

    # FIXME
    postInstall = ''
      cp -r ffi/include $out/include
    '';

    meta = with lib; {
      description = "A library for parsing and evaluating LOOT's metadata condition strings";
      homepage = "https://github.com/loot/loot-condition-interpreter";
      license = licenses.mit;
      maintainers = [ maintainers.schnusch ];
    };
  };

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
