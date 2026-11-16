{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  cmake,
  cli11,
  dotwriter,
  eigen,
  fmt,
  nlohmann_json,
  protobuf,
  spdlog,
  xxhash,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hailort";
  version = "4.24.0";
  strictDeps = true;

  src = /tmp/hailort;
  asrc = fetchFromGitHub {
    owner = "hailo-ai";
    repo = "hailort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NMjAtIyQkX/cJoI7JjB8KRWMJGG4Pzqw0hDXkyR6kQg=";
  };

  # patches = [
  #   ./system-deps.patch

  #   # migrate from spdlog/fmt to fmt
  #   ./fmt-compat.patch

  #   # requires a fork of cli11 from 2022 just for completions
  #   ./drop-cli11-completions.patch
  # ];

  postPatch = ''
    substituteInPlace hailort/cmake/execute_cmake.cmake \
      --replace-fail "bash" "${lib.getExe bash}"
  '';

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "HAILO_OFFLINE_COMPILATION" true)
  ];

  buildInputs = [
    cli11
    dotwriter
    eigen
    fmt
    nlohmann_json
    protobuf
    spdlog
    xxhash
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex '^4\\..*$'" ];
  };

  __structuredAttrs = true;

  meta = {
    description = "An open source light-weight and high performance inference framework for Hailo devices";
    homepage = "https://github.com/hailo-ai/hailort";
    license = with lib.licenses; AND [
      mit # libhailort, pyhailort, hailortcli
      lgpl21Plus # hailonet gstreamer plugin
    ];
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "hailort";
    platforms = lib.platforms.all;
  };
})
