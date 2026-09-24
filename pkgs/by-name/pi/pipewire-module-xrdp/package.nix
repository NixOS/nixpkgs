{
  stdenv,
  fetchFromGitHub,
  lib,
  pipewire,
  autoreconfHook,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pipewire-module-xrdp";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = "pipewire-module-xrdp";
    rev = "v${version}";
    hash = "sha256-7UspJxpxFy/W15Hz4mtLCIxx42t+vpnRxNJk67BmWJk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pipewire-0.3 $out/libexec/pipewire-xrdp-module $out/etc/xdg/autostart
    install -m 755 src/.libs/*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/pipewire-0.3

    install -m 755 instfiles/load_pw_modules.sh $out/libexec/pipewire-xrdp-module/pipewire_xrdp_init
    substituteInPlace $out/libexec/pipewire-xrdp-module/pipewire_xrdp_init \
      --replace-fail status=0 "status=0; export PIPEWIRE_MODULE_DIR=/run/current-system/sw/lib/pipewire-0.3" \
      --replace-fail pactl ${pipewire}/bin/pactl

    install -m 644 instfiles/pipewire-xrdp.desktop.in $out/etc/xdg/autostart/pipewire-xrdp.desktop
    substituteInPlace $out/etc/xdg/autostart/pipewire-xrdp.desktop \
      --replace-fail @pkglibexecdir@/load_pw_modules.sh $out/libexec/pipewire-xrdp-module/pipewire_xrdp_init

    runHook postInstall
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pipewire.dev
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "xrdp sink/source pipewire modules";
    homepage = "https://github.com/neutrinolabs/pipewire-module-xrdp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ i-love-lean ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
