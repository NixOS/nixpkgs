{
  lib,
  stdenv,
  fetchFromGitHub,
  bashInteractive,
  bison,
  cmake,
  flex,
  gsettings-desktop-schemas,
  gtk3,
  harfbuzz,
  hunspell,
  libssh,
  libedit,
  lldb,
  makeWrapper,
  openssl,
  pcre2,
  pkg-config,
  clang,
  sqlite,
  universal-ctags,
  which,
  wrapGAppsHook3,
  wxwidgets_3_2,
  xterm,
  yaml-cpp,
  enableSFTP ? true,
  enableLLDB ? false,
}:

let
  # Git submodules of codelite that are not packaged in nixpkgs (most of them
  # are forks maintained by the codelite author), pinned to the commits that
  # the 18.5.0 tag points to.
  submodules = {
    "agent-sop" = fetchFromGitHub {
      owner = "strands-agents";
      repo = "agent-sop";
      rev = "666897b95da9756d906cbfff1be123fe527b64f8";
      hash = "sha256-QDKRfJ6HS0QX+miUYk8+/9IO9f3GakN4mUrsWzw8UCg=";
    };
    "assistant" = fetchFromGitHub {
      owner = "eranif";
      repo = "assistant";
      rev = "6462fb53604e3c0ab69cd48a1ed5eae35cc2b32a";
      hash = "sha256-nFDIm24+GtxppQPKg80sbml4x1Ic0GZC/ccuC1SA6fc=";
    };
    "cc-wrapper" = fetchFromGitHub {
      owner = "eranif";
      repo = "cc-wrapper";
      rev = "53464674ff2c287dfd68f05030d1d79e02d4974c";
      hash = "sha256-3Z3b+AP9txRxg7UO+dtWjtOeI6h1xaIrJWWWvKdKEF8=";
    };
    "cc-wrapper/tinyjson" = fetchFromGitHub {
      owner = "eranif";
      repo = "tinyjson";
      rev = "d51ef6fc646d60c1400ebde767ebfdd2b7361482";
      hash = "sha256-dw9kbl9xVmPeOoLX4JJki6OQyfBHUi58SwfR6leyvdk=";
    };
    "dtl" = fetchFromGitHub {
      owner = "cubicdaiya";
      repo = "dtl";
      rev = "32567bb9ec704f09040fb1ed7431a3d967e3df03";
      hash = "sha256-s+syRiJhcxvmE0FBcbCi6DrL1hwu+0IJNMgg5Tldsv4=";
    };
    "lexilla" = fetchFromGitHub {
      owner = "eranif";
      repo = "lexilla";
      rev = "8502988a5eb83fcd281ee5a38533a9f170e6b2bf";
      hash = "sha256-RpZUTROTVU/HnZOHBgvxA5Pj0msMgy4ex+Px5sBy6d8=";
    };
    "lua" = fetchFromGitHub {
      owner = "eranif";
      repo = "lua";
      rev = "d939306e46fa5e4a68e9becd2f5809a40ad49fe1";
      hash = "sha256-stgrJEqcgSSWINmONi0fmbtNCXxbqMPTKi33TBSK+oE=";
    };
    "LuaBridge" = fetchFromGitHub {
      owner = "eranif";
      repo = "LuaBridge";
      rev = "a78d4f1469890eb4e795709848ebf57b002ad369";
      hash = "sha256-68BhD6F6i1sQkiYSrn409zqX2efuw5KSm1J3HZ9ZFWg=";
    };
    "wxdap" = fetchFromGitHub {
      owner = "eranif";
      repo = "wxdap";
      rev = "2eee32020c5309136358d422230abe24411d657f";
      hash = "sha256-snNjQR/7qLJTPjKvFe2YGjbY0s/VYwpezqn30KEVluY=";
    };
    "wxTerminalEmulator" = fetchFromGitHub {
      owner = "eranif";
      repo = "wxTerminalEmulator";
      rev = "5216c4a034bdbbc08022bbd71a03a034bd5ccf7d";
      hash = "sha256-UD+XKf9YLcae9wC6TnnE2p3NVrbLwjAac9F0GGIIPcE=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codelite";
  version = "18.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eranif";
    repo = "codelite";
    tag = finalAttrs.version;
    hash = "sha256-sQ0CnXwPDf9h/p9uTzTU+DziGpXbNucbL8I/ZfcVzoY=";
  };

  postPatch = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: src: "mkdir -p submodules/${name} && cp -rT --no-preserve=mode ${src} submodules/${name}"
      ) submodules
    )}

    # /bin/bash does not exist on NixOS. Only patch the places that run on the
    # local machine (not the ones used for Docker, Remoty or SSH).
    substituteInPlace \
      Plugins/ClaudeCode/ClaudeCodePage.cpp \
      Plugin/wxTerminalCtrl/clBuiltinTerminalPane.hpp \
      Plugin/wxterminal.cpp \
      Plugin/pipedprocess.cpp \
      Plugin/custombuildrequest.cpp \
      Plugin/TerminalEmulator/TerminalEmulator.cpp \
      CodeLite/fileutils.cpp \
      CodeLite/Console/clConsoleBash.cpp \
      CodeLite/Console/clConsoleGnomeTerminal.cpp \
      CodeLite/Console/clConsoleGnomeConsole.cpp \
      CodeLite/Console/clConsoleRXVTerminal.cpp \
      --replace-fail "/bin/bash" "${lib.getExe bashInteractive}"

    # Use the system yaml-cpp instead of the bundled submodule
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(submodules/yaml-cpp)' 'find_package(yaml-cpp REQUIRED)' \
      --replace-fail 'set(LIBYAML_CPP "yaml-cpp")' 'set(LIBYAML_CPP yaml-cpp::yaml-cpp)' \
      --replace-fail 'include_directories("''${CL_SRC_ROOT}/submodules/yaml-cpp/include")' "" \
      --replace-fail 'add_dependencies(codelite yaml-cpp)' ""
    substituteInPlace Plugin/CMakeLists.txt \
      --replace-fail 'PRIVATE "''${CL_SRC_ROOT}/submodules/yaml-cpp/include"' 'PRIVATE'
  '';

  nativeBuildInputs = [
    bison
    cmake
    flex
    makeWrapper
    pkg-config
    universal-ctags
    which
    wrapGAppsHook3
    wxwidgets_3_2
  ];

  buildInputs = [
    clang
    gsettings-desktop-schemas
    gtk3
    harfbuzz
    harfbuzz.dev
    hunspell
    libedit
    openssl
    pcre2
    sqlite
    universal-ctags
    wxwidgets_3_2
    xterm
    yaml-cpp
  ]
  ++ lib.optionals enableSFTP [ libssh ]
  ++ lib.optionals enableLLDB [ lldb ];

  preConfigure = ''
    export PATH="${wxwidgets_3_2}/bin:$PATH"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${harfbuzz.dev}/include/harfbuzz"
  '';

  # CMAKE_SKIP_INSTALL_RPATH drops the RPATH entries that point into the build
  # directory (rejected by Nix), but also the one to codelite's own libraries
  env.NIX_LDFLAGS = "-rpath ${placeholder "out"}/lib/codelite";

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SFTP" enableSFTP)
    (lib.cmakeBool "ENABLE_LLDB" enableLLDB)
    (lib.cmakeBool "WITH_PCH" false)
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "CMAKE_SKIP_INSTALL_RPATH" true)
  ];

  postFixup = ''
    wrapProgram "$out/bin/codelite" \
      --prefix PATH : ${lib.makeBinPath [ xterm ]}
  '';

  meta = {
    description = "Open source, cross platform C/C++/PHP/Node.js/Rust IDE";
    homepage = "https://codelite.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sincorchetes ];
    platforms = lib.platforms.linux;
    mainProgram = "codelite";
  };
})
