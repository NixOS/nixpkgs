{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "byedpi";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "hufrea";
    repo = "byedpi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l9Clkdq4E8mgCQM4AsdDv6pB/3SBChp71P0yQKRtMSY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 ciadpi $out/bin/ciadpi
    runHook postInstall
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOCKS proxy server implementing some DPI bypass methods";
    homepage = "https://github.com/hufrea/byedpi";
    changelog = "https://github.com/hufrea/byedpi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = with lib.platforms; linux ++ windows;
    mainProgram = "ciadpi";
  };
})
