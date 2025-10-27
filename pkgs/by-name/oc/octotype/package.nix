{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octotype";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "mahlquistj";
    repo = "octotype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-klvfANkwJUpmQf5imA3sc60n3zcvyJor0YzbO4Z2r+I=";
  };
  cargoHash = "sha256-9d0m7iYcUBikW9lOeiN5EF1a0zMK8SoKv9QMN1IpmEU=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    install -Dm644 modes/default.toml $out/share/octotype/modes/default.toml
    install -Dm644 modes/perfectionism.toml $out/share/octotype/modes/perfectionism.toml
    install -Dm644 modes/wordcount.toml $out/share/octotype/modes/wordcount.toml

    mkdir -p $out/share/octotype/sources
    substitute sources/random.toml $out/share/octotype/sources/random.toml \
      --replace-fail './gibberish.sh' './random.sh'
    install -Dm755 sources/random.sh $out/share/octotype/sources/random.sh

    wrapProgram $out/bin/octotype \
      --run 'CONFIG_DIR=''${XDG_CONFIG_HOME:-$HOME/.config}/octotype; mkdir -p "$CONFIG_DIR"/{modes,sources}; [ ! -f "$CONFIG_DIR/modes/default.toml" ] && cp '"$out"'/share/octotype/modes/*.toml "$CONFIG_DIR/modes/" 2>/dev/null || true; [ ! -f "$CONFIG_DIR/sources/random.toml" ] && cp '"$out"'/share/octotype/sources/* "$CONFIG_DIR/sources/" 2>/dev/null || true'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mahlquistj/octotype/releases/tag/v${finalAttrs.version}";
    description = "TUI typing trainer inspired by monkeytype with a focus on customization";
    homepage = "https://github.com/mahlquistj/octotype";
    license = lib.licenses.mit;
    mainProgram = "octotype";
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
  };
})
