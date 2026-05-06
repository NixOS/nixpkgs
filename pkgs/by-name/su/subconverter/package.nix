{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  nix-update-script,

  curl,
  libcron,
  pcre2,
  quickjs,
  quickjspp,
  rapidjson,
  toml11,
  yaml-cpp,
  howard-hinnant-date,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subconverter";
  version = "0.9.0-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "tindy2013";
    repo = "subconverter";
    rev = "5b8d3af0d7b659e3ff6029560e4a6811538a9c21";
    hash = "sha256-gfzjH/KtgcfESv3SjJSRsx6GmoDbhjfPI7B9NdfyV9o=";
  };

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail 'setcd(prgpath);' '// setcd(prgpath); read-only nix store'
  '';

  outputs = [
    "out"
    "data"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    toml11
    yaml-cpp
    pcre2
    quickjs
    quickjspp
    libcron
    rapidjson
    howard-hinnant-date
  ];

  # Fix link error by aliasing the unhandled promise API to the legacy symbol.
  #   undefined reference to `JS_SetHostUnhandledPromiseRejectionTracker'
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DJS_SetHostUnhandledPromiseRejectionTracker=JS_SetHostPromiseRejectionTracker")
  ];

  # to fix `realpath` buffer overflow detection crash
  hardeningDisable = [ "fortify" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 subconverter $out/bin/subconverter
    cp -r $src/base $data

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to convert between various subscription format";
    longDescription = ''
      Subconverter is a tool to convert between various subscription formats.

      Note:
      Unlike the upstream releases, this package does not include
      configuration files alongside the binary in the read-only Nix store.
      It runs in your current working directory.

      To run subconverter properly, prepare a working directory with
      the configuration files.

      ```bash
      mkdir -p ~/subconverter && cd ~/subconverter

      # Copy default assets
      cp -r $(nix-build '<nixpkgs>' -A subconverter.data --no-out-link)/* .
      chmod -R +w .

      subconverter
      ```
    '';
    homepage = "https://github.com/tindy2013/subconverter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "subconverter";
    platforms = lib.platforms.linux;
  };
})
