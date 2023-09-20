{ lib
, stdenv
, fetchFromGitHub
, boost
, cxxopts
, libpulseaudio
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "pamixer";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = version;
    hash = "sha256-LbRhsW2MiTYWSH6X9Pz9XdJdH9Na0QCO8CFmlzZmDjQ=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  buildInputs = [ boost cxxopts libpulseaudio ];

  meta = with lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by its id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = "https://github.com/cdemoulins/pamixer";
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "pamixer";
  };
}
