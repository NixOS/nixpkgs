{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

buildGo127Module (finalAttrs: {
  pname = "dux-calendar";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "duxlabs-dev";
    repo = "dux-calendar";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-a+9wcGGdyTfffUXO/bHfxll8uQfTQ97LeNZuz9kXFNk=";
  };

  modRoot = "core";

  vendorHash = "sha256-fsrxRMdOG+XfAHBnnhtOsP/8tRl7vyHhT9mPUiozqQ8=";

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
    install -Dm644 $src/assets/dev.duxlabs.calendar.desktop \
      $out/share/applications/dev.duxlabs.calendar.desktop
    install -Dm644 $src/assets/dev.duxlabs.calendar.svg \
      $out/share/icons/hicolor/scalable/apps/dev.duxlabs.calendar.svg

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
    description = "Local, Google, Microsoft, and CalDAV calendars from Dux Labs";
    homepage = "https://github.com/duxlabs-dev/dux-calendar";
    changelog = "https://github.com/duxlabs-dev/dux-calendar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.th1nkk1d ];
    teams = [ lib.teams.duxlabs ];
    mainProgram = "dcal";
    platforms = lib.platforms.linux;
  };
})
