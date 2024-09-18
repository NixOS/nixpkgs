{
  lib,
  stdenv,
  fetchFromGitHub,

  rustPlatform,
  rust-cbindgen,

  cmake,
  pkg-config,

  doxygen,
  python3,

  boost,
  fmt_11,
  gtest,
  icu,
  spdlog,
  tbb_2021_11,
  yaml-cpp,
}:

let
  testing-plugins = fetchFromGitHub {
    owner = "Ortham";
    repo = "testing-plugins";
    rev = "refs/tags/1.6.2";
    hash = "sha256-3Aa98EwqpuGA3YlsRF8luWzXVEFO/rs6JXisXdLyIK4=";
  };

  buildRustFFIPackage =
    args:
    rustPlatform.buildRustPackage (
      args
      // {
        postConfigure = ''
          cp -r --no-preserve=all ${testing-plugins} testing-plugins
        '';

        nativeBuildInputs = [ rust-cbindgen ];

        buildAndTestSubdir = "ffi";

        postBuild = ''
          cbindgen ffi/ -l $lang -o $out/include/$header
        '';
      }
    );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libloot";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "loot";
    repo = "libloot";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Y0YYPlfCkXW+ONmXZ/C/jV/VEkagXzt3qHhN5zjxBUw=";
  };

  patches = [ ./deps.patch ];

  postPatch = ''
    substituteInPlace src/api/plugin.{h,cpp} \
        --replace-fail 'Vec_PluginMetadata' 'Vec<::PluginMetadata>'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config

    doxygen
    python3.pkgs.sphinx
    python3.pkgs.sphinx-rtd-theme
    python3.pkgs.breathe
  ];

  buildInputs = [
    boost
    fmt_11
    gtest
    icu
    (spdlog.override { fmt = fmt_11; })
    tbb_2021_11
    yaml-cpp

    finalAttrs.passthru.libloadorder
    finalAttrs.passthru.esplugin
    finalAttrs.passthru.loot-condition-interpreter
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TESTING-PLUGINS" "${testing-plugins}")
    (lib.cmakeFeature "ESPLUGIN_LIBRARIES" "esplugin_ffi")
    (lib.cmakeFeature "LIBLOADORDER_LIBRARIES" "loadorder_ffi")
    (lib.cmakeFeature "LCI_LIBRARIES" "loot_condition_interpreter_ffi")
  ];

  postBuild = ''
    sphinx-build -b html ../docs docs/html
  '';

  passthru = {
    libloadorder = buildRustFFIPackage rec {
      pname = "libloadorder";
      version = "18.0.0";

      src = fetchFromGitHub {
        owner = "Ortham";
        repo = "libloadorder";
        rev = "refs/tags/${version}";
        hash = "sha256-jU1rQW6T328OeJYIgwwZ76xT6mBzVO59ybN0G+5gXD0=";
      };

      cargoHash = "sha256-mUsJ2qihUFT3uct6a6JthWYkzRE/o1VEwJ/UYRfl9tE=";

      lang = "c++";
      header = "libloadorder.hpp";
    };

    esplugin = buildRustFFIPackage rec {
      pname = "esplugin";
      version = "6.1.0";

      src = fetchFromGitHub {
        owner = "Ortham";
        repo = "esplugin";
        rev = "refs/tags/${version}";
        hash = "sha256-OqiDXEr14WSoIxb615Lt5vyoD4O6MY/a1uIyHjXVW7s=";
      };

      cargoHash = "sha256-7bQWzTtPVDZMmlK25IWshAC9sEUNfz+lAuxjhvctb/U=";

      lang = "c++";
      header = "esplugin.hpp";
    };

    loot-condition-interpreter = buildRustFFIPackage rec {
      pname = "loot-condition-interpreter";
      version = "4.0.1";

      src = fetchFromGitHub {
        owner = "loot";
        repo = "loot-condition-interpreter";
        rev = "refs/tags/${version}";
        hash = "sha256-sFdtpf+TaKfAbvK5oplb77uAIRdcLw3XfGYYVZ37XAM=";
      };

      cargoHash = "sha256-h0Lm/jzCzD19JrJYk5yp8XvbhFNO3LKGbS7WPyw0GDk=";

      lang = "c";
      header = "loot_condition_interpreter.h";
    };
  };

  meta = {
    description = "C++ library for accessing LOOT's metadata and sorting functionality";
    homepage = "https://github.com/loot/libloot";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
