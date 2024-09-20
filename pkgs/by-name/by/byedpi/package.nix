{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "byedpi";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "hufrea";
    repo = "byedpi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Sf5Ik8+9nKhum4/faGf44Y/gQggldyRsFUVmd9XPKOA=";
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
