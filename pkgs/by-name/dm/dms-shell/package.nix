{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  procps,
  nix-update-script,
  bashNonInteractive,
}:

buildGoModule rec {
  pname = "dms-shell";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "DankMaterialShell";
    tag = "v${version}";
    hash = "sha256-dLbiTWsKoF0if/Wqet/+L90ILdAaBqp+REGOou8uH3k=";
  };

  sourceRoot = "${src.name}/core";

  vendorHash = "sha256-nc4CvEPfJ6l16/zmhnXr1jqpi6BeSXd3g/51djbEfpQ=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/dms" ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    mkdir -p $out/share/quickshell
    cp -r ${src}/quickshell $out/share/quickshell/dms

    wrapProgram $out/bin/dms --add-flags "-c $out/share/quickshell/dms"

    install -Dm644 ${src}/quickshell/assets/systemd/dms.service \
      $out/lib/systemd/user/dms.service
    substituteInPlace $out/lib/systemd/user/dms.service \
      --replace-fail /usr/bin/dms $out/bin/dms \
      --replace-fail /usr/bin/pkill ${procps}/bin/pkill

    substituteInPlace $out/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
      --replace-fail /bin/bash ${bashNonInteractive}/bin/bash

    installShellCompletion --cmd dms \
      --bash <($out/bin/dms completion bash) \
      --fish <($out/bin/dms completion fish) \
      --zsh <($out/bin/dms completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Desktop shell for wayland compositors built with Quickshell & GO";
    homepage = "https://danklinux.com";
    changelog = "https://github.com/AvengeMedia/DankMaterialShell/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luckshiba ];
    mainProgram = "dms";
    platforms = lib.platforms.linux;
  };
}
