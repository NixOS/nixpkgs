{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anker-powerconf-c200-linux-tools";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erans";
    repo = "anker-powerconf-c200-linux-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-txIVTbqxnFQ8GcJgxTp89Qc3U5CXkYolXCO4E1PXHHA=";
  };

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/bin
    cp ./build/anker-powerconf-c200-linux-tools "$out"/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux CLI tools for the Anker PowerConf C200 webcam";
    mainProgram = "anker-powerconf-c200-linux-tools";
    homepage = "https://github.com/erans/anker-powerconf-c200-linux-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fernsehmuell ];
    platforms = lib.platforms.linux;
  };
})
