{stdenv, fetchurl, libX11, libXft}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "xfractint";
  version = "20.04p14";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://www.fractint.net/ftp/current/linux/xfractint-${version}.tar.gz";
    sha256 = "0jdqr639z862qrswwk5srmv4fj5d7rl8kcscpn6mlkx4jvjmca0f";
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
    homepage = https://www.fractint.net/;
  };
}
