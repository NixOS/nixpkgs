{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iprange-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/firehol/iprange/releases/download/v${version}/iprange-${version}.tar.xz";
    sha256 = "0lwgl5ybrhsv43llq3kgdjpvgyfl43f3nxm0g8a8cd7zmn754bg2";
  };

  meta = with stdenv.lib; {
    description = "manage IP ranges";
    homepage = https://github.com/firehol/iprange;
    license = licenses.gpl2;
    maintainers = with maintainers; [ geistesk ];
  };
}
