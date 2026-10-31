{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gettext,
  fcitx5,
  makeBinaryWrapper,
  qt6,
  autoPatchelfHook,
  systemdLibs,
  curl,
  libarchive,
  openssl,
  pipewire,
  cli11,
  nlohmann_json,
  clang,
  mold,
  onnxruntime,
  sherpa-onnx,
  libopus,
  python3,
  nix-update-script,
  enableLocalAsr ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if enableLocalAsr then "fcitx5-vinput" else "fcitx5-vinput-lite";
  version = "2.4.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xifan2333";
    repo = "fcitx5-vinput";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jZxyxDEUYuGDh7c27yiGYn6BW0KzfgwX+HW9nXmvCoo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    fcitx5
    makeBinaryWrapper
    qt6.wrapQtAppsHook
    autoPatchelfHook
    clang
    mold
  ];

  buildInputs = [
    fcitx5
    systemdLibs
    curl
    libarchive
    openssl
    pipewire
    qt6.qtbase
    cli11
    nlohmann_json
  ]
  ++ lib.optionals enableLocalAsr [
    onnxruntime
    sherpa-onnx
  ];

  cmakeFlags = [
    # "bundled" copies the sherpa-onnx and onnxruntime libraries that find_library() located
    # out of the store into $out/lib/fcitx5-vinput, and points the daemon's INSTALL_RPATH at
    # that directory. "system" links against the store copies instead and installs nothing.
    (lib.cmakeFeature "VINPUT_RUNTIME_MODE" "system")
    (lib.cmakeBool "VINPUT_ENABLE_LOCAL_ASR" enableLocalAsr)
    (lib.cmakeBool "VINPUT_FETCH_CLI11" false)
    (lib.cmakeBool "VINPUT_FETCH_NLOHMANN_JSON" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_C_COMPILER" "clang")
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "clang++")
    (lib.cmakeFeature "CMAKE_LINKER" "mold")
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-fuse-ld=mold")
    (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-fuse-ld=mold")
  ];

  # The command provider shells out to python3 and dlopens libopus. The Qt hook
  # leaves these binaries alone (the Qt code lives in the plugin .so), so wrap
  # them here, skipping anything it did wrap.
  postFixup = ''
    for program in $out/bin/*; do
      if head -c 2 "$program" | grep -q '#!'; then
        continue
      fi
      wrapProgram "$program" \
        --prefix PATH : ${lib.makeBinPath [ python3 ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libopus ]}
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description =
      if enableLocalAsr then
        "Voice input addon for Fcitx5 with local and cloud ASR"
      else
        "Voice input addon for Fcitx5, built without local ASR";
    homepage = "https://github.com/xifan2333/fcitx5-vinput";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ myul ];
    platforms = lib.platforms.linux;
    mainProgram = "vinput";
  };
})
