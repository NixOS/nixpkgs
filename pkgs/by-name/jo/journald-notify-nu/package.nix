{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  libnotify,
  systemd,
  writers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "journald-notify-nu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wvhulle";
    repo = "journald-notify-nu";
    rev = "6d8356a040c4406caf253925fc0cc24e82af0963";
    hash = "sha256-aUn5nnPZq06Q11MxUsGw6076vGDmIW2PPMf9u1x+F8s=";
  };

  buildInputs = [
    libnotify
    nushell
    systemd
  ];

  installPhase = ''
        runHook preInstall

        # Install the nushell module
        install -Dm644 mod.nu $out/share/journald-notify-nu/mod.nu

        # Create wrapper scripts
        mkdir -p $out/bin
        cat > $out/bin/journald-notify-nu << EOF
    #!/usr/bin/env -S nu --no-config-file
    use $out/share/journald-notify-nu/mod.nu; mod main
    EOF
        chmod +x $out/bin/journald-notify-nu

        cat > $out/bin/journald-notify-monitor << EOF
    #!/usr/bin/env -S nu --no-config-file
    use $out/share/journald-notify-nu/mod.nu; mod start-monitoring \$env.1?
    EOF
        chmod +x $out/bin/journald-notify-monitor

        cat > $out/bin/journald-notify-test << EOF
    #!/usr/bin/env -S nu --no-config-file
    use $out/share/journald-notify-nu/mod.nu; mod test-notification
    EOF
        chmod +x $out/bin/journald-notify-test

        runHook postInstall
  '';

  meta = {
    description = "Nushell package for converting systemd journal entries to desktop notifications";
    homepage = "https://github.com/wvhulle/journald-notify-nu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wvhulle ];
    platforms = lib.platforms.linux;
    mainProgram = "journald-notify-nu";
  };
})
