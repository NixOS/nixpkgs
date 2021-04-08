{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpulseaudio
, glib
, pango
, gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "myxer";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Aurailus";
    repo = pname;
    rev = version;
    sha256 = "1yszcqz5yc8gjxc8w3rdmihk9sbadp86jvn2jplljk9qw10jnylx";
  };

  cargoSha256 = "0s8smqr2nn6kkm7l7j4kc1lr6xax57nsgwmsnhx5g76xwinl79c9";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpulseaudio glib pango gtk3 ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "A modern Volume Mixer for PulseAudio";
    homepage = "https://github.com/Aurailus/Myxer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erin ];
    platforms = platforms.linux;
  };
}
