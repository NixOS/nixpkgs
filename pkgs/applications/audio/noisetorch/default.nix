{ stdenv, buildGoModule, fetchFromGitHub, rnnoise-plugin }:

buildGoModule rec {
  pname = "NoiseTorch";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "NoiseTorch";
    rev = version;
    sha256 = "1a4g112h83m55pga8kq2a1wzxpycj59v4bygyjfyi1s09q1y97qg";
  };

  patches = [ ./version.patch ];

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "." ];

  buildInputs = [ rnnoise-plugin ];

  postPatch = "substituteInPlace main.go --replace 'librnnoise_ladspa/bin/ladspa/librnnoise_ladspa.so' '$RNNOISE_LADSPA_PLUGIN'";

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
