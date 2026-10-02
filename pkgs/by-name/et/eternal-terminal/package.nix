{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,

  gflags,
  libsodium,
  openssl,
  protobuf,
  zlib,
  httplib,
  nlohmann_json,
  libutempter,
  libunwind,
  cxxopts,
  simpleini,
  platform-folders,
  catch2_3,

  withSelinux ? stdenv.hostPlatform.isLinux,
  libselinux,
  libsepol,
  pcre2,
}:

let
  keepVendored = [
    # https://github.com/abumq/easyloggingpp
    "easyloggingpp"
    # https://github.com/progschj/ThreadPool
    "ThreadPool"
    # https://github.com/arsenm/sanitizers-cmake
    "sanitizers-cmake"
    # https://github.com/MisterTea/UniversalStacktrace
    "UniversalStacktrace"
    # https://github.com/r-lyeh-archived/sole
    "sole"
    # https://github.com/tkislan/base64
    "base64"
  ];

  deleteVendoredDependencies = rootDir: ''
    echo "removing vendored dependencies..."
    find "${rootDir}/external_imported" \
      -type d \
      -mindepth 1 -maxdepth 1 \
      \! \( ${lib.concatMapStringsSep " -o " (n: "-name \"${n}\"") keepVendored} \) \
      -print \
      -exec rm -r {} +
    rm -rfv "${rootDir}"/external_imported/easyloggingpp/{doc,samples,test,tools}
    rm -rfv "${rootDir}/external_imported/UniversalStacktrace/external"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "eternal-terminal";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    tag = "et-v${finalAttrs.version}";
    hash = "sha256-uZnjtSubTljFlbIZEznfEmNRaUWsuZotRapn0wexkow=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  patches = [
    ./cmake-cxx-version.patch
    ./thread-pool-c++20-result-of.patch

    # Upstream allows either using vcpkg (and discovery using find_package) or using vendored dependencies
    # Instead, use discovery of our packages via find_package while disabling vcpkg
    ./cmake-disable-vcpkg.patch

    # Allow using platform-folders and simpleini from nixpkgs
    ./cmake-unvendor-simpleini.patch
    ./cmake-unvendor-platform-folders.patch
  ];

  postPatch = deleteVendoredDependencies ".";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gflags
    libsodium
    openssl
    protobuf
    zlib
    httplib
    nlohmann_json
    libunwind
    cxxopts
    platform-folders
    simpleini
    libutempter
  ]
  ++ lib.optionals withSelinux [
    libselinux
    libsepol
    pcre2
  ];

  checkInputs = [
    catch2_3
  ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_VCPKG" false)
    (lib.cmakeBool "DISABLE_SENTRY" true)
    (lib.cmakeBool "DISABLE_CRASH_LOG" true)

    (lib.cmakeOptionType "PATH" "BASH_COMPLETION_COMPLETIONSDIR"
      "${placeholder "out"}/share/bash-completion/completions"
    )
    (lib.cmakeOptionType "PATH" "ZSH_COMPLETIONS_DIR" "${placeholder "out"}/share/zsh/site-functions")
  ];

  doCheck = true;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  checkPhase = ''
    ctest --output-on-failure -E 'et-test\.LargeInputNoDeadlock'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Remote shell that automatically reconnects without interrupting the session";
    homepage = "https://eternalterminal.dev/";
    changelog = "https://github.com/MisterTea/EternalTerminal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jshort
      tomasrivera
    ];
    mainProgram = "et";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
