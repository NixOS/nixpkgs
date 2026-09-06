{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  nlohmann_json,
  spdlog,
  argparse,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d2hs";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "neboer";
    repo = "DNS2HostsSyncer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AYORL/efnE5OiRyVAFMlJUsbL1XBG6QAKjGWOYv+iEM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    nlohmann_json
    spdlog
    argparse
    curl
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall
    install -Dm755 ./d2hs $out/bin/d2hs
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Neboer/DNS2HostsSyncer";
    description = "Small tool for periodically syncing dns records to hosts";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      peigongdsd
    ];
    mainProgram = "d2hs";
  };
})
