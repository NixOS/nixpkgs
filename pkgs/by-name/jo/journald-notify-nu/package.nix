{
  lib,
  stdenv,
  fetchFromGitHub,
  nushell,
  libnotify,
  systemd,
  writeShellScript,
}:

let
  pname = "journald-notify-nu";
  version = "0.1.0";

  wrapperScripts = {
    journald-notify-nu = writeShellScript "journald-notify-nu" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod main"
    '';

    journald-notify-monitor = writeShellScript "journald-notify-monitor" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod start-monitoring ''${1:-}"
    '';

    journald-notify-test = writeShellScript "journald-notify-test" ''
      exec ${nushell}/bin/nu -c "use ${placeholder "out"}/share/${pname}/mod.nu; mod test-notification"
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

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

    # Install the Nu module
    install -Dm644 mod.nu $out/share/journald-notify-nu/mod.nu

    # Create simple shell script wrappers
    install -Dm755 ${wrapperScripts.journald-notify-nu} $out/bin/journald-notify-nu
    install -Dm755 ${wrapperScripts.journald-notify-monitor} $out/bin/journald-notify-monitor
    install -Dm755 ${wrapperScripts.journald-notify-test} $out/bin/journald-notify-test

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
