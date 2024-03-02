{ lib, stdenv, fetchFromGitHub, libjack2, libsndfile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "jack_capture";
  version = "0.9.73.2023-01-04";

  src = fetchFromGitHub {
    owner = "kmatheussen";
    repo = "jack_capture";
    rev = "a539d444d388c4cfed7279e385830e7767d59c41";
    sha256 = "sha256-2DavZS4esV17a3vkiPvfCfp0QF94ZcXqdIw84h9HDjA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjack2 libsndfile ];

  buildPhase = "PREFIX=$out make jack_capture";

  installPhase = ''
    mkdir -p $out/bin
    cp jack_capture $out/bin/
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A program for recording soundfiles with jack";
    homepage = "https://github.com/kmatheussen/jack_capture/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ goibhniu orivej ];
    platforms = lib.platforms.linux;
  };
}
