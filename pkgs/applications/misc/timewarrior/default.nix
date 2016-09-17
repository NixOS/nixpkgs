{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "1.0.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/timew-${version}.tar.gz";
    sha256 = "1d8b9sjdbdld81n535iwip9igl16kcw452wa47fmndp8w487j0mc";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp -rv doc/man/*.1 $out/share/man/man1
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

