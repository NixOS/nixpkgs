{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "1.0.0.beta1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/timew-${version}.tar.gz";
    sha256 = "1gkh07mw8hiqslw8ps35r9lp5jbdy93s0sdrcbp34dd5h99qx587";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -rv doc/man $out/share/
    cp src/timew $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = http://tasktools.org/projects/timewarrior.html;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}

