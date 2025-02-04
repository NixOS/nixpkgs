{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
  portaudio,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "gnaural";
  version = "20110606";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}_${version}.tar.xz";
    hash = "sha256-0a09DUMfHEIGYuIYSBGJalBiIHIgejr/KVDXCFgKBb8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    libsndfile
    portaudio
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: src/net/../gnauralnet.h:233: multiple definition of `GN_ScheduleFingerprint';
  #     src/net/../../src/gnauralnet.h:233: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    mkdir -p $out/share/applications
    substitute \
      $out/share/gnome/apps/Multimedia/gnaural.desktop \
      $out/share/applications/gnaural.desktop \
      --replace \
        "/usr/share/gnaural/pixmaps/gnaural-icon.png" \
        "$out/share/gnaural/pixmaps/gnaural-icon.png" \

    rm -rf $out/share/gnome
  '';

  meta = with lib; {
    description = "Programmable auditory binaural-beat synthesizer";
    homepage = "https://gnaural.sourceforge.net/";
    maintainers = with maintainers; [ ehmry ];
    license = with licenses; [ gpl2Only ];
    mainProgram = "gnaural";
  };
}
