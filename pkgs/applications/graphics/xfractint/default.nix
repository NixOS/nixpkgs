{stdenv, fetchurl, libX11, libXft}:
stdenv.mkDerivation rec {
  pname = "xfractint";
  version = "20.04p15";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://www.fractint.net/ftp/current/linux/xfractint-${version}.tar.gz";
    sha256 = "1wv2hgyjvrjxzqxb55vz65ra80p24j8sd34llykk2qlx73x8f3nk";
  };

  buildInputs = [libX11 libXft];

  configurePhase = ''
    sed -e 's@/usr/bin/@@' -i Makefile
  '';

  makeFlags = ["PREFIX=$(out)"];

  meta = {
    inherit version;
    description = "";
    # Code cannot be used in commercial programs
    # Looks like the definition hinges on the price, not license
    license = stdenv.lib.licenses.unfree;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://www.fractint.net/";
  };
}
