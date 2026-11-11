{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  stdenv,
  bubblewrap,
  ffmpegthumbnailer,
  poppler-utils,
  quickshell,
}:

# Upstream requires Go 1.27, while the default buildGoModule still uses Go 1.26.
buildGoLatestModule (finalAttrs: {
  pname = "dux-files";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-files";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RH7H1mdX8Iswh69kcXOlfKw05MvBvqNC0UHaTr9VVso=";
  };

  modRoot = "core";
  vendorHash = "sha256-FiRXQZtakQYiPn0ZqK+k+rG5ZcoaDm16T5t6Ankq/h8=";

  subPackages = [ "cmd/dfiles" ];
  tags = [ "withshell" ];

  postPatch = ''
    make -C core sync-shell
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    install -Dm644 $src/assets/dev.duxlabs.files.desktop \
      $out/share/applications/dev.duxlabs.files.desktop
    install -Dm644 $src/assets/dev.duxlabs.files.svg \
      $out/share/icons/hicolor/scalable/apps/dev.duxlabs.files.svg
    install -Dm644 $src/assets/dev.duxlabs.files.metainfo.xml \
      $out/share/metainfo/dev.duxlabs.files.metainfo.xml
    install -Dm644 $src/assets/dev.duxlabs.files.policy \
      $out/share/polkit-1/actions/dev.duxlabs.files.policy
    install -Dm644 $src/assets/dbus/dev.duxlabs.files.FileManager1.service \
      $out/share/dbus-1/services/dev.duxlabs.files.FileManager1.service
    install -Dm644 $src/assets/dbus/org.freedesktop.impl.portal.desktop.dfiles.service \
      $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.dfiles.service
    install -Dm644 $src/assets/portal/dfiles.portal \
      $out/share/xdg-desktop-portal/portals/dfiles.portal
    install -Dm644 $src/assets/systemd/dfiles.service \
      $out/lib/systemd/user/dfiles.service

    substituteInPlace $out/share/applications/dev.duxlabs.files.desktop \
      --replace-fail 'Exec=dfiles ' "Exec=$out/bin/dfiles "
    substituteInPlace \
      $out/share/dbus-1/services/dev.duxlabs.files.FileManager1.service \
      $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.dfiles.service \
      $out/lib/systemd/user/dfiles.service \
      --replace-fail /usr/bin/dfiles $out/bin/dfiles

    wrapProgram $out/bin/dfiles \
      --prefix PATH : ${
        lib.makeBinPath [
          quickshell
          bubblewrap
          ffmpegthumbnailer
          poppler-utils
        ]
      }

    # pkexec authorizes the executable behind the wrapper.
    substituteInPlace $out/share/polkit-1/actions/dev.duxlabs.files.policy \
      --replace-fail /usr/bin/dfiles $out/bin/.dfiles-wrapped
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dfiles \
      --bash <($out/bin/dfiles completion bash) \
      --fish <($out/bin/dfiles completion fish) \
      --zsh <($out/bin/dfiles completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "File manager for Wayland built with Quickshell and Go";
    homepage = "https://github.com/duxlabs-dev/dux-files";
    changelog = "https://github.com/duxlabs-dev/dux-files/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.duxlabs ];
    mainProgram = "dfiles";
    platforms = lib.platforms.linux;
  };
})
