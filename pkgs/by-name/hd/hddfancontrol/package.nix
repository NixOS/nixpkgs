{
  lib,
  rustPlatform,
  fetchFromGitHub,
  hddtemp,
  hdparm,
  sdparm,
  smartmontools,
  makeWrapper,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hddfancontrol";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "hddfancontrol";
    tag = finalAttrs.version;
    hash = "sha256-Fqkx2pO97RCFa1vFTCuMsO+WVs/2WGLsHwyKcuEnq5I=";
  };

  cargoHash = "sha256-8NNFL5aeQjdXP/qw9yxL2fFOJaLUVM2GJ0YSW5OuR4A=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postBuild = ''
    mkdir -p target/man target/shell-completions
    cargo run --features generate-extras -- gen-man-pages target/man
    cargo run --features generate-extras -- gen-shell-completions target/shell-completions
  '';

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    substitute systemd/hddfancontrol.service $out/etc/systemd/system/hddfancontrol.service \
      --replace-fail /usr/bin/hddfancontrol $out/bin/hddfancontrol
    sed -i -e '/EnvironmentFile=.*/d' $out/etc/systemd/system/hddfancontrol.service

    installManPage target/man/*.1

    installShellCompletion --cmd hddfancontrol \
      --bash target/shell-completions/hddfancontrol.bash \
      --fish target/shell-completions/hddfancontrol.fish \
      --zsh target/shell-completions/_hddfancontrol
  '';

  postFixup = ''
    wrapProgram $out/bin/hddfancontrol \
      --prefix PATH : ${
        lib.makeBinPath [
          hddtemp
          hdparm
          sdparm
          smartmontools
        ]
      }
  '';

  meta = {
    description = "Dynamically control fan speed according to hard drive temperature on Linux";
    changelog = "https://github.com/desbma/hddfancontrol/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/desbma/hddfancontrol";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      benley
      philipwilk
    ];
    mainProgram = "hddfancontrol";
    platforms = lib.platforms.linux;
  };
})
