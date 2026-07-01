{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clashtui";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "JohanChane";
    repo = "clashtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-roP252d0lO7eN2KCHiuPPI5o8QqtPWJvmeex8sAmKww=";
  };

  cargoHash = "sha256-7y31iZoSJ98XDiC+Akahgfp/lI5haaek6UpFtaCtGW8=";

  # Copy the default configs so the mihomo/sing-box service can read.
  postInstall = ''
    mkdir -p $out/share/clashtui
    cp -r contrib/default_configs $out/share/clashtui/default_configs
  '';

  passthru = {
    tests.clashtui = nixosTests.clashtui;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mihomo (Clash.Meta) / sing-box TUI Client";
    homepage = "https://github.com/JohanChane/clashtui";
    changelog = "https://github.com/JohanChane/clashtui/releases/tag/v${finalAttrs.version}";
    mainProgram = "clashtui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
