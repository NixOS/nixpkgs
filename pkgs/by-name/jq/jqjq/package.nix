{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  bashNonInteractive,
  jaq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jqjq";
  version = "0-unstable-2025-06-02";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jqjq";
    rev = "46aabe64866de73bdc0b68cbaf6659266fe03254";
    hash = "sha256-ypfT8L9ujBGbi1P2R1WmEN6lw3K2NI8d4GRZEcRhjx4=";
  };

  # So checkPhase can run
  postPatch = "patchShebangs --build jqjq.jq";

  strictDeps = true;
  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [
    bashNonInteractive
  ];
  dontBuild = true;

  doCheck = true;
  nativeCheckInputs = [
    jaq
    bashNonInteractive
  ];

  # For some reason it doesn't detect the Makefile
  checkPhase = ''
    runHook preCheck

    make JQ=jaq test-jqjq

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share"
    cp jqjq.jq "$out/share/jqjq.jq"

    makeWrapper "$out/share/jqjq.jq" "$out/bin/jqjq" \
      --set JQ ${lib.getExe jaq}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/jqjq" --run-tests < ${finalAttrs.src}/jqjq.test

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "jq implementation in jq";
    homepage = "https://github.com/wader/jqjq";
    maintainers = with lib.maintainers; [ RossSmyth ];
    mainProgram = "jqjq";
    license = lib.licenses.mit;
    platforms = jaq.meta.platforms;
  };
})
