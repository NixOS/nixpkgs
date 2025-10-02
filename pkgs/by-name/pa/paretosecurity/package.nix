{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  paretosecurity,
  nixosTests,
  pkg-config,
  gtk3,
  webkitgtk_4_1,
}:

buildGoModule (finalAttrs: {
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];
  pname = "paretosecurity";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "ParetoSecurity";
    repo = "agent";
    rev = finalAttrs.version;
    hash = "sha256-pqqcyWFyJX5IJkkLxAafbQu/8yygBsQL1/BAENFdk4g=";
  };

  vendorHash = "sha256-6OQ9SPr9z+uoGeeJwo3jrr1nMECcHgULMvjn2G4uLx4=";
  proxyVendor = true;

  # Skip building the Windows installer
  preBuild = ''
    rm -rf cmd/paretosecurity-installer
  '';

  ldflags = [
    "-s"
    "-X=github.com/ParetoSecurity/agent/shared.Version=${finalAttrs.version}"
    "-X=github.com/ParetoSecurity/agent/shared.Commit=${finalAttrs.src.rev}"
    "-X=github.com/ParetoSecurity/agent/shared.Date=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    # Install global systemd files
    install -Dm400 ${finalAttrs.src}/apt/paretosecurity.socket $out/lib/systemd/system/paretosecurity.socket
    install -Dm400 ${finalAttrs.src}/apt/paretosecurity.service $out/lib/systemd/system/paretosecurity.service
    substituteInPlace $out/lib/systemd/system/paretosecurity.service \
        --replace-fail "/usr/bin/paretosecurity" "$out/bin/paretosecurity"

    # Install user systemd files
    install -Dm444 ${finalAttrs.src}/apt/paretosecurity-user.timer $out/lib/systemd/user/paretosecurity-user.timer
    install -Dm444 ${finalAttrs.src}/apt/paretosecurity-user.service $out/lib/systemd/user/paretosecurity-user.service
    substituteInPlace $out/lib/systemd/user/paretosecurity-user.service \
        --replace-fail "/usr/bin/paretosecurity" "$out/bin/paretosecurity"
    install -Dm444 ${finalAttrs.src}/apt/paretosecurity-trayicon.service $out/lib/systemd/user/paretosecurity-trayicon.service
    substituteInPlace $out/lib/systemd/user/paretosecurity-trayicon.service \
        --replace-fail "/usr/bin/paretosecurity" "$out/bin/paretosecurity"

    # Install .desktop files
    install -Dm444 ${finalAttrs.src}/apt/ParetoSecurity.desktop $out/share/applications/ParetoSecurity.desktop
    substituteInPlace $out/share/applications/ParetoSecurity.desktop \
        --replace-fail "/usr/bin/paretosecurity" "$out/bin/paretosecurity"
    install -Dm444 ${finalAttrs.src}/apt/ParetoSecurityLink.desktop $out/share/applications/ParetoSecurityLink.desktop
    substituteInPlace $out/share/applications/ParetoSecurityLink.desktop \
        --replace-fail "/usr/bin/paretosecurity" "$out/bin/paretosecurity"

    # Install icon
    install -Dm444 ${finalAttrs.src}/assets/icon.png $out/share/icons/hicolor/512x512/apps/ParetoSecurity.png
  '';

  passthru.tests = {
    version = testers.testVersion {
      inherit (finalAttrs) version;
      package = paretosecurity;
    };
    integration_test = nixosTests.paretosecurity;
  };

  meta = {
    description = "A simple trayicon app that makes sure your laptop is correctly configured for security";
    longDescription = ''
      [Pareto Desktop](https://paretosecurity.com/linux) is a free and open
      source trayicon app to help you configure your laptop for security. It
      nudges you to take care of 20% of security-related tasks that bring 80% of
      protection.

      In it's simplest form, it's a CLI command that prints out a report on basic
      security settings such as if you have disk encryption and firewall enabled.

      If you use the `services.paretosecurity` NixOS module, you also get a
      root helper that allows you to run the checker in userspace. Some checks
      require root permissions, and the checker asks the helper to run those.

      Additionally, using the NixOS module gets you a little Vilfredo Pareto
      living in your systray showing your the current status of checks. The
      NixOS Module also installs a systemd timer to update the status of checks
      once per hour. If you want to use just the CLI mode, set
      `services.paretosecurity.trayIcon` to `false`.

      Finally, if you set `users.users.alice.paretosecurity.inviteId = "..."`
      to the `inviteId` you get on [Pareto Cloud](https://cloud.paretosecurity.com/),
      then Pareto Desktop acts as a read-only and push-only agent that sends the
      status of checks to https://cloud.paretosecurity.com which makes
      compliance people happy and your privacy intact.
    '';
    homepage = "https://github.com/ParetoSecurity/agent";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zupo ];
    mainProgram = "paretosecurity";
  };
})
