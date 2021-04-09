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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Aurailus";
    repo = pname;
    rev = version;
    sha256 = "10m5qkys96n4v6qiffdiy0w660yq7b5sa70ww2zskc8d0gbmxp6x";
  };

  cargoSha256 = "0nsscdjl5fh24sg87vdmijjmlihc0zk0p3vac701v60xlz55qipn";

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
