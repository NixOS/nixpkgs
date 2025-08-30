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

    # Install the Nu module
    install -Dm644 mod.nu $out/share/journald-notify-nu/mod.nu

    # Create Nu script wrappers by copying and substituting path
    mkdir -p $out/bin

    cp ${writers.writeNuBin "journald-notify-nu" ''use PLACEHOLDER/share/journald-notify-nu/mod.nu; mod main''}/bin/journald-notify-nu $out/bin/journald-notify-nu
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/journald-notify-nu
    chmod +x $out/bin/journald-notify-nu

    cp ${writers.writeNuBin "journald-notify-monitor" ''
      use PLACEHOLDER/share/journald-notify-nu/mod.nu
      mod start-monitoring
    ''}/bin/journald-notify-monitor $out/bin/journald-notify-monitor
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/journald-notify-monitor
    chmod +x $out/bin/journald-notify-monitor

    cp ${writers.writeNuBin "journald-notify-test" ''use PLACEHOLDER/share/journald-notify-nu/mod.nu; mod test-notification''}/bin/journald-notify-test $out/bin/journald-notify-test
    sed -i "s|PLACEHOLDER|$out|g" $out/bin/journald-notify-test
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
