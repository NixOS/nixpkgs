{ stdenv, fetchFromGitHub, fetchpatch, boost, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "pamixer-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = version;
    sha256 = "15zs2x4hnrpxphqn542b6qqm4ymvhkvbcfyffy69d6cki51chzzw";
  };

  # Remove after https://github.com/cdemoulins/pamixer/pull/16 gets fixed
  patches = [(fetchpatch {
    url = "https://github.com/oxij/pamixer/commit/dea1cd967aa837940e5c0b04ef7ebc47a7a93d63.patch";
    sha256 = "0s77xmsiwywyyp6f4bjxg1sqdgms1k5fiy7na6ws0aswshfnzfjb";
  })];

  buildInputs = [ boost libpulseaudio ];

  installPhase = ''
    mkdir -p $out/bin
    cp pamixer $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by his id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = https://github.com/cdemoulins/pamixer;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
