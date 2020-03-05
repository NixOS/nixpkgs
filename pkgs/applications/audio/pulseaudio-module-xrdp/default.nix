{ stdenv, runCommand, fetchFromGitHub
, pkgconfig, autoconf, automake, libtool
, pulseaudio }:

let
  # extract config.h and src directories from pulseaudio
  pulseaudio' = pulseaudio.overrideDerivation (p: {
    outputs = ["out"];
    phases = ["unpackPhase" "configurePhase" "installPhase"];

    installPhase = ''
      mkdir -p $out
      cp config.h $out
      cp -r src $out
    '';
  });

in stdenv.mkDerivation rec {
  pname = "pulseaudio-module-xrdp";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = "pulseaudio-module-xrdp";
    rev = "v${version}";
    sha256 = "0855bp93n9wshpsyb112qr3bf496xxrkshf6cdlaizj7lknpbcbb";
  };

  PULSE_DIR = pulseaudio';

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [
    "--with-module-dir=$(out)/lib/pulse-${pulseaudio.version}/modules"
  ];

  nativeBuildInputs = [
    pkgconfig autoconf automake libtool
  ];

  buildInputs = [
    pulseaudio
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/neutrinolabs/pulseaudio-module-xrdp;
    description = "Xrdp sink / source pulseaudio modules";
    platforms = platforms.linux;
    license = with licenses; [ asl20 lgpl2Plus ];
    maintainers = with maintainers; [ offline ];
  };
}
