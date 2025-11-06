{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "illuminanced";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mikhail-m1";
    repo = "illuminanced";
    tag = "${finalAttrs.version}";
    hash = "sha256-ZEVma0uj9rsWB+vfUL7w3dHxI/ppBCG23TirGE+RREk=";
  };

  cargoHash = "sha256-kPWoQ6rE4wBjmqQLNPY4UWJt/AOgr+eVKY0ZK7B4K1A=";

  preBuild = ''
    substituteInPlace src/main.rs \
      --replace-fail /usr/local/etc/illuminanced.toml $out/share/illuminanced/illuminanced.toml
  '';

  postInstall = ''
    install -Dm0644 illuminanced.toml $out/share/illuminanced/illuminanced.toml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ambient Light Sensor Daemon for Linux";
    homepage = "https://github.com/mikhail-m1/illuminanced";
    changelog = "https://github.com/mikhail-m1/illuminanced/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dynamicgoose
    ];
    mainProgram = "illuminanced";
    platforms = lib.platforms.linux;
  };
})
