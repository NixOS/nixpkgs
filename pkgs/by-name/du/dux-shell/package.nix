{
  lib,
  buildGo127Module,
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

buildGo127Module (
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
    pname = "dux-shell";
    version = "2.0.0";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "duxlabs-dev";
      repo = "dux-shell";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-TLb0rbQlxBJOFTVzp7PMEZiKytWn4UnJE2Gfpa+wrbk=";
    };

    sourceRoot = "${finalAttrs.src.name}/core";

    vendorHash = "sha256-fN7v7DuWaqhtD28cTr0FZUIyW7nUqhQoVuatsL2fuo4=";

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

    preBuild = ''
      chmod -R u+w ../quickshell

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
      install -D ${finalAttrs.src}/assets/dev.duxlabs.shell.desktop \
        $out/share/applications/dev.duxlabs.shell.desktop
      install -D ${finalAttrs.src}/assets/dev.duxlabs.shell.notepad.desktop \
        $out/share/applications/dev.duxlabs.shell.notepad.desktop
      install -D ${finalAttrs.src}/assets/dev.duxlabs.shell.svg \
        $out/share/icons/hicolor/scalable/apps/dev.duxlabs.shell.svg
      install -D ${finalAttrs.src}/core/assets/danklogo.svg \
        $out/share/icons/hicolor/scalable/apps/danklogo.svg

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
      description = "Desktop shell for Wayland compositors built with Quickshell and Go";
      homepage = "https://duxlabs.dev";
      changelog = "https://github.com/duxlabs-dev/dux-shell/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      teams = [ lib.teams.duxlabs ];
      mainProgram = "dms";
      platforms = lib.platforms.linux;
    };
  }
)
