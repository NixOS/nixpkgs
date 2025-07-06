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
  version = "0.2.38";

  src = fetchFromGitHub {
    owner = "ParetoSecurity";
    repo = "agent";
    rev = finalAttrs.version;
    hash = "sha256-+2QHLSekDaH8Ltq5UbQIG+GeLO8e1tYK4QPSeOB20YY=";
  };

  vendorHash = "sha256-GMbP34qjn/4ffTW5fxTMdzommcpHf9t3yZJ/jm4Tuzg=";
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
    description = "Pareto Security agent makes sure your laptop is correctly configured for security.";
    longDescription = ''
      The Pareto Security agent is a free and open source app to help you make
      sure that your laptop is configured for security.

      By default, it's a CLI command that prints out a report on basic security
      settings such as if you have disk encryption and firewall enabled.

      If you use the `services.paretosecurity` NixOS module, you also get a
      root helper that allows you to run the checker in userspace. Some checks
      require root permissions, and the checker asks the helper to run those.

      Additionally, using the NixOS module gets you a little Vilfredo Pareto
      living in your systray showing your the current status of checks. The
      NixOS Module also installs a systemd timer to update the status of checks
      once per hour. If you want to use just the CLI mode, set
      `services.paretosecurity.trayIcon` to `false`.

      Finally, you can run `paretosecurity link` to configure the agent
      to send the status of checks to https://dash.paretosecurity.com to make
      compliance people happy. No sending happens until your device is linked.
    '';
    homepage = "https://github.com/ParetoSecurity/agent";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zupo ];
    mainProgram = "paretosecurity";
  };
})
