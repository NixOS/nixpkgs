{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  procps,
  nix-update-script,
  bashNonInteractive,
  fprintd,
  kdePackages,
  qt6,
}:

buildGoModule (
  finalAttrs:
  let
    qmlPkgs = with kdePackages; [
      kirigami.unwrapped
      sonnet
      qtmultimedia
    ];

    qmlImportPath = lib.concatStringsSep ":" (map (o: "${o}/${qt6.qtbase.qtQmlPrefix}") qmlPkgs);
    qtPluginPath = lib.concatStringsSep ":" (map (o: "${o}/${qt6.qtbase.qtPluginPrefix}") qmlPkgs);
  in
  {
    pname = "dms-shell";
    version = "1.2.3";

    src = fetchFromGitHub {
      owner = "AvengeMedia";
      repo = "DankMaterialShell";
      tag = "v${finalAttrs.version}";
      hash = "sha256-P//moH3z9r4PXirTzXVsccQINsK5AIlF9RWOBwK3vLc=";
    };

    sourceRoot = "${finalAttrs.src.name}/core";

    vendorHash = "sha256-9CnZFtjXXWYELRiBX2UbZvWopnl9Y1ILuK+xP6YQZ9U=";

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${finalAttrs.version}"
    ];

    subPackages = [ "cmd/dms" ];

    nativeBuildInputs = [
      installShellFiles
      makeWrapper
    ];

    postInstall = ''
      mkdir -p $out/share/quickshell/dms
      cp -r ${finalAttrs.src}/quickshell/. $out/share/quickshell/dms/

      install -D ${finalAttrs.src}/assets/dms-open.desktop \
        $out/share/applications/dms-open.desktop
      install -D ${finalAttrs.src}/core/assets/danklogo.svg \
        $out/share/hicolor/scalable/apps/danklogo.svg

      wrapProgram $out/bin/dms \
        --add-flags "-c $out/share/quickshell/dms" \
        --prefix "NIXPKGS_QT6_QML_IMPORT_PATH" ":" "${qmlImportPath}" \
        --prefix "QT_PLUGIN_PATH" ":" "${qtPluginPath}"

      install -Dm644 ${finalAttrs.src}/assets/systemd/dms.service \
        $out/lib/systemd/user/dms.service

      substituteInPlace $out/lib/systemd/user/dms.service \
        --replace-fail /usr/bin/dms $out/bin/dms \
        --replace-fail /usr/bin/pkill ${procps}/bin/pkill

      substituteInPlace $out/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
        --replace-fail /bin/bash ${bashNonInteractive}/bin/bash

      substituteInPlace $out/share/quickshell/dms/assets/pam/fprint \
        --replace-fail pam_fprintd.so ${fprintd}/lib/security/pam_fprintd.so

      installShellCompletion --cmd dms \
        --bash <($out/bin/dms completion bash) \
        --fish <($out/bin/dms completion fish) \
        --zsh <($out/bin/dms completion zsh)
    '';

    passthru = {
      updateScript = nix-update-script { };
    };

    meta = {
      description = "DankMaterialShell - Desktop shell for wayland compositors built with Quickshell & GO";
      homepage = "https://danklinux.com";
      changelog = "https://github.com/AvengeMedia/DankMaterialShell/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      teams = [ lib.teams.danklinux ];
      mainProgram = "dms";
      platforms = lib.platforms.linux;
    };
  }
)
