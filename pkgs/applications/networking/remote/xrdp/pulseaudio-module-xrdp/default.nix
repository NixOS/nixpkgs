{ stdenv
, fetchFromGitHub
, lib
, nix-update-script
, pulseaudio
, autoreconfHook
, pkg-config
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "pulseaudio-module-xrdp";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GT0kBfq6KvuiX30B9JzCiUxgSm9E6IhdJuQKKKprDCE=";
  };

  preConfigure = ''
    tar -xvf ${pulseaudio.src}
    mv pulseaudio-* pulseaudio-src
    chmod +w -Rv pulseaudio-src
    cp ${pulseaudio.dev}/include/pulse/config.h pulseaudio-src
    configureFlags="$configureFlags PULSE_DIR=$(realpath ./pulseaudio-src)"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pulseaudio/modules $out/libexec/pulsaudio-xrdp-module $out/etc/xdg/autostart
    install -m 755 src/.libs/*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/pulseaudio/modules

    install -m 755 instfiles/load_pa_modules.sh $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init
    substituteInPlace $out/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init \
      --replace pactl ${pulseaudio}/bin/pactl

    runHook postInstall
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pulseaudio.dev
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) xrdp-with-audio-pulseaudio;
    };
  };

  meta = with lib; {
    description = "xrdp sink/source pulseaudio modules";
    homepage = "https://github.com/neutrinolabs/pulseaudio-module-xrdp";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lucasew ];
    platforms = platforms.linux;
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
