{ stdenv, fetchurl, boost, pulseaudio }:

stdenv.mkDerivation rec {

  name = "pamixer-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/cdemoulins/pamixer/archive/${version}.tar.gz";
    sha256 = "1ad6b46hh02hs1978pgihrm2bnq4z2v0imrfm3wy74xdkr6xjxy4";
  };

  buildInputs = [ boost pulseaudio ];

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
    maintainers = with maintainers; [ _1126 ];
    platforms = platforms.linux;
  };
}
