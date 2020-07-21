{ stdenv, buildGoModule, fetchFromGitHub, rnnoise-plugin }:

buildGoModule rec {
  pname = "NoiseTorch";
  version = "0.5.2-beta";

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "NoiseTorch";
    rev = version;
    sha256 = "1q0gfpqczlpybxcjjkiybcy6yc0gnrq8x27r0mpg4pvgwy7mps47";
  };

  patches = [ ./version.patch ./config.patch ./embedlibrnnoise.patch ];

  vendorSha256 = null;

  subPackages = [ "." ];

  buildInputs = [ rnnoise-plugin ];

  preBuild = ''
    export RNNOISE_LADSPA_PLUGIN="${rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
    go generate;
    rm  ./scripts/*
  '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp assets/icon/noisetorch.png $out/share/icons/hicolor/256x256/apps/
    mkdir -p $out/share/applications/
    cp assets/noisetorch.desktop $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Virtual microphone device with noise supression for PulseAudio";
    homepage = "https://github.com/lawl/NoiseTorch";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ panaeon ];
  };
}
