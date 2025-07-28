{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  makeWrapper,
  libnotify,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "journald-notify-nu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wvhulle";
    repo = "journald-notify-nu";
    rev = "247174e5a9c6b8d2e1f5a4c3b6e9d8f7a5c4b3e2"; # Will be updated when pushed
    hash = "sha256-0000000000000000000000000000000000000000000="; # Will be updated
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ nushell ];

  buildInputs = [
    libnotify
    systemd
  ];

  installPhase = ''
        runHook preInstall

        # Install the nushell module
        mkdir -p $out/share/journald-notify-nu
        cp mod.nu $out/share/journald-notify-nu/

        # Install NixOS module
        mkdir -p $out/share/nixos/modules
        cp nixos-module.nix $out/share/nixos/modules/journald-notify-nu.nix

        # Create wrapper scripts for command-line usage
        mkdir -p $out/bin

        # Main monitoring script
        cat > $out/bin/journald-notify-nu << EOF
    #!/usr/bin/env bash
    exec ${nushell}/bin/nu -c "use $out/share/journald-notify-nu/mod.nu; mod main"
    EOF
        chmod +x $out/bin/journald-notify-nu

        # Custom monitoring script
        cat > $out/bin/journald-notify-monitor << EOF
    #!/usr/bin/env bash
    exec ${nushell}/bin/nu -c "use $out/share/journald-notify-nu/mod.nu; mod start-monitoring \$1"
    EOF
        chmod +x $out/bin/journald-notify-monitor

        # Test notification script
        cat > $out/bin/journald-notify-test << EOF
    #!/usr/bin/env bash
    exec ${nushell}/bin/nu -c "use $out/share/journald-notify-nu/mod.nu; mod test-notification"
    EOF
        chmod +x $out/bin/journald-notify-test

        runHook postInstall
  '';

  passthru = {
    nixosModules.journald-notify-nu = import "${placeholder "out"}/share/nixos/modules/journald-notify-nu.nix";
  };

  meta = {
    description = "A nushell package for converting systemd journal entries to desktop notifications";
    homepage = "https://github.com/wvhulle/journald-notify-nu";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wvhulle ];
    platforms = lib.platforms.linux;
    mainProgram = "journald-notify-nu";
  };
}
