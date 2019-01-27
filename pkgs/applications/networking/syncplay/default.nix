{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "syncplay-${version}";
  version = "1.6.2";

  format = "other";

  src = fetchurl {
    url = https://github.com/Syncplay/syncplay/archive/v1.6.2.tar.gz;
    sha256 = "1850icvifq4487gqh8awvmvrjdbbkx2kshmysr0fbi6vcf0f3wj2";
  };

  propagatedBuildInputs = with python3Packages; [ pyside twisted ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://syncplay.pl/;
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ enzime ];
  };
}
