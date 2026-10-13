{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "dankcalendar";
  version = "1.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dankcalendar";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Gaa6FkFLuX4g2oivHypbs6f8zf9wRWny5sAIndNDj7A=";
  };

  modRoot = "core";

  vendorHash = "sha256-sCGKtWWOzARUz+whX6tDfWTYb8jIGO3o4fhndMGCm9c=";

  subPackages = [ "cmd/dcal" ];

  # Embeds the quickshell UI into the binary, as upstream's Makefile does for
  # releases. Untagged builds carry no UI and require an external shell dir.
  tags = [ "withshell" ];

  postPatch = ''
    make -C core sync-shell
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    install -Dm644 $src/assets/com.danklinux.dankcalendar.desktop \
      $out/share/applications/com.danklinux.dankcalendar.desktop
    install -Dm644 $src/assets/com.danklinux.dankcalendar.svg \
      $out/share/icons/hicolor/scalable/apps/com.danklinux.dankcalendar.svg

    install -Dm644 $src/assets/systemd/dcal.service \
      $out/lib/systemd/user/dcal.service
    substituteInPlace $out/lib/systemd/user/dcal.service \
      --replace-fail /usr/bin/dcal $out/bin/dcal
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dcal \
      --bash <($out/bin/dcal completion bash) \
      --fish <($out/bin/dcal completion fish) \
      --zsh <($out/bin/dcal completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Local, Google, Microsoft, and CalDAV calendars for the dank desktop";
    homepage = "https://github.com/AvengeMedia/dankcalendar";
    changelog = "https://github.com/AvengeMedia/dankcalendar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.th1nkk1d ];
    teams = [ lib.teams.danklinux ];
    mainProgram = "dcal";
    platforms = lib.platforms.linux;
  };
})
