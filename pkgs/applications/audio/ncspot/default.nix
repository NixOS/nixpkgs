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
  pname = "ncspot";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    rev = "v${version}";
    sha256 = "10jp2yh8jlvdwh297658q9fi3i62vwsbd9fbwjsir7s1c9bgdy8k";
  };

  cargoSha256 = "0081wc3xw11hivz0nwy4my3y4a53ch857bq989dr0pm9p2pirvj1";

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
