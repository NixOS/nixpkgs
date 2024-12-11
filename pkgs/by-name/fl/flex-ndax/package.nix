{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpulseaudio,
}:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.4-20240818";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    hash = "sha256-FCF22apO6uAc24H36SkvfKEKdyqY4l+j7ABdOnhZP6M=";
  };

  buildInputs = [ libpulseaudio ];

  vendorHash = "sha256-05LWJm4MoJqjJaFrBZvutKlqSTGl4dSp433AfHHO6LU=";

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description = "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nDAX";
  };
}
