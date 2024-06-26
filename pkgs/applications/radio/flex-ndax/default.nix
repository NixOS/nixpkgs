{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpulseaudio,
}:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.3-20230126.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    hash = "sha256-co2S3DrdGeoNneqNyifd+Z1z5TshyD+FgHkiSRqK3SQ=";
  };

  buildInputs = [ libpulseaudio ];

  vendorHash = "sha256-eHy8oFYicVONQr31LQQ9b5auzeBoIzbszw2buKaBQbQ=";

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description = "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nDAX";
  };
}
