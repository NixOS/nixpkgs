{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "0.9.5.alpha";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/timew-${version}.tar.gz";
    sha256 = "154d5sgxcmz1b7g401c7s6sf7pkk0hh74dx6rss3vkamsjc4wgl8";
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

