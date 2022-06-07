{ stdenv
, lib
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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Aurailus";
    repo = pname;
    rev = version;
    sha256 = "0bnhpzmx4yyasv0j7bp31q6jm20p0qwcia5bzmpkz1jhnc27ngix";
  };

  cargoSha256 = "1cyh0nk627sgyr78rcnhj7af5jcahvjkiv5sz7xwqfdhvx5kqsk5";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpulseaudio glib pango gtk3 ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A modern Volume Mixer for PulseAudio";
    homepage = "https://github.com/Aurailus/Myxer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erin ];
    platforms = platforms.linux;
  };
}
