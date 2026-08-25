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
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dankcalendar";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-UcTWQJwkMkI1aPvkWwHITRUiqaOfP6JKlStzetkOQ88=";
  };

  modRoot = "core";

  vendorHash = "sha256-m0blu+mzoY4HyIBmyPV8lUirWT9oVL+PxXBupvTEM8c=";

  subPackages = [ "cmd/dcal" ];

  # Embeds the quickshell UI into the binary, as upstream's Makefile does for
  # releases. Untagged builds carry no UI and require an external shell dir.
  tags = [ "withshell" ];

  # Mirror `make -C core sync-shell`: bake the quickshell UI into the
  # binary, minus dev-only files. The DankCommon symlink points into the
  # dank-qml-common submodule and would dangle after the copy, so it is
  # replaced with the real directory.
  postPatch = ''
    rm -rf core/internal/shellembed/dist
    cp -r quickshell core/internal/shellembed/dist
    rm -f core/internal/shellembed/dist/DankCommon
    cp -r dank-qml-common/DankCommon core/internal/shellembed/dist/DankCommon
    chmod -R u+w core/internal/shellembed/dist
    rm -rf core/internal/shellembed/dist/scripts \
      core/internal/shellembed/dist/.claude
    rm -f core/internal/shellembed/dist/.qmlls.ini \
      core/internal/shellembed/dist/translations/extract_translations.py
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
