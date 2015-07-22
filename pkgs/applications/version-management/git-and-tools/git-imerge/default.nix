{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "git-imerge-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/mhagger/git-imerge/archive/${version}.tar.gz";
    sha256 = "00nwn3rfhf15wsv01lfji5412d7yz827ric916lnyp662d6gx206";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython ];

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mhagger/git-imerge;
    description = "Perform a merge between two branches incrementally";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}
