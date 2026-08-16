{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  json_c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hexagonrpc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "hexagonrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OC6wXBCIW4XznWG0zzxRK3BzWMVK2Jq/gTL36sJV1PE=";
  };

  outputs = [
    "out"
    "tools"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    json_c
  ];

  # sscregistrygen is only compiled when json-c is available and meson doesn't install it
  postInstall = ''
    mkdir -p $tools/bin
    install -Dm755 tools/sscregistrygen $tools/bin/sscregistrygen
  '';

  meta = {
    description = "Daemon to communicate with Qualcomm DSPs";
    homepage = "https://github.com/linux-msm/hexagonrpc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "hexagonrpcd";
    platforms = lib.platforms.all;
  };
})
