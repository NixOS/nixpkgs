{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  coreutils,
  fprintd,
  kdePackages,
  pam,
  pam_u2f,
  qt6,
}:

buildGoModule (
  finalAttrs:
  let
    qmlPkgs = with kdePackages; [
      kirigami.unwrapped
      sonnet
      qtmultimedia
      qtimageformats
      kimageformats
    ];

    qmlImportPath = lib.concatStringsSep ":" (map (o: "${o}/${qt6.qtbase.qtQmlPrefix}") qmlPkgs);
    qtPluginPath = lib.concatStringsSep ":" (map (o: "${o}/${qt6.qtbase.qtPluginPrefix}") qmlPkgs);
  in
  {
    pname = "dms-shell";
    version = "1.6.0";

    src = fetchFromGitHub {
      owner = "AvengeMedia";
      repo = "DankMaterialShell";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-e/QOEY1bwjsR+LLdSMQHdIhIOCuRTZ+0jCQ6kEpzABY=";
    };

    sourceRoot = "${finalAttrs.src.name}/core";

    vendorHash = "sha256-nswS/ygp0oYMXp6YHbbIxBha4xvzjKAxcAS5yOpbslg=";

    tags = [ "withshell" ];

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

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail \
          '@tar -C $(SHELL_SRC) --exclude=.qmlls.ini -chf - . | tar -C $(EMBED_DIR) -xf -' \
          '@tar -C $(SHELL_SRC) --exclude=.qmlls.ini -chf - . | tar -C $(EMBED_DIR) -xf - && chmod -R u+w $(EMBED_DIR)'
    '';

    preBuild = ''
      substituteInPlace ../quickshell/assets/pam/fprint \
        --replace-fail pam_fprintd.so ${fprintd}/lib/security/pam_fprintd.so \
        --replace-fail pam_deny.so ${pam}/lib/security/pam_deny.so \
        --replace-fail pam_permit.so ${pam}/lib/security/pam_permit.so

      substituteInPlace ../quickshell/assets/pam/u2f \
        --replace-fail pam_u2f.so ${pam_u2f}/lib/security/pam_u2f.so \
        --replace-fail pam_deny.so ${pam}/lib/security/pam_deny.so \
        --replace-fail pam_permit.so ${pam}/lib/security/pam_permit.so

      substituteInPlace ../quickshell/assets/pam/other \
        --replace-fail pam_deny.so ${pam}/lib/security/pam_deny.so

      make sync-shell
    '';

    postInstall = ''
      install -D ${finalAttrs.src}/assets/dms-open.desktop \
        $out/share/applications/dms-open.desktop
      install -D ${finalAttrs.src}/assets/com.danklinux.dms.desktop \
        $out/share/applications/com.danklinux.dms.desktop
      install -D ${finalAttrs.src}/assets/com.danklinux.dms.notepad.desktop \
        $out/share/applications/com.danklinux.dms.notepad.desktop
      install -D ${finalAttrs.src}/core/assets/danklogo.svg \
        $out/share/hicolor/scalable/apps/danklogo.svg

      wrapProgram $out/bin/dms \
        --run 'export DMS_ORIG_NIXPKGS_QT6_QML_IMPORT_PATH="''${NIXPKGS_QT6_QML_IMPORT_PATH:-}"' \
        --run 'export DMS_ORIG_QT_PLUGIN_PATH="''${QT_PLUGIN_PATH:-}"' \
        --prefix "NIXPKGS_QT6_QML_IMPORT_PATH" ":" "${qmlImportPath}" \
        --prefix "QT_PLUGIN_PATH" ":" "${qtPluginPath}"

      install -Dm644 ${finalAttrs.src}/assets/systemd/dms.service \
        $out/lib/systemd/user/dms.service

      substituteInPlace $out/lib/systemd/user/dms.service \
        --replace-fail /usr/bin/dms $out/bin/dms \
        --replace-fail /bin/kill ${coreutils}/bin/kill

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
