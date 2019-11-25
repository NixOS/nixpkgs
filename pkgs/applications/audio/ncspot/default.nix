{ lib, fetchFromGitHub, rustPlatform, pkg-config, ncurses, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
}:

let
  features = [ "cursive/pancurses-backend" ]
    ++ lib.optional withALSA "alsa_backend"
    ++ lib.optional withPulseAudio "pulseaudio_backend"
    ++ lib.optional withPortAudio "portaudio_backend";
in
rustPlatform.buildRustPackage rec {
  pname = "ncspot-unstable";
  version = "2019-10-12";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "4defded54646958268a20787917e4721ae96407d";
    sha256 = "1w3cmilwjzk3pfnq97qgz6hzxgjgi27dm8jq7maw87qyl3v17gyg";
  };

  cargoSha256 = "1w1fk39pragfy2i2myw99mqf63w6fw4nr2kri8ily2iqc6g9xpgw";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional withALSA alsaLib
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio;

  doCheck = false;

  meta = with lib; {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
