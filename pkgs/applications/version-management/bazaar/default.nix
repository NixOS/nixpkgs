{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "bazaar-1.1";

  src = fetchurl {
    url = http://launchpad.net/bzr/1.3/1.3.1/+download/bzr-1.3.1.tar.gz;
    sha256 = "1d81bm8cdim6a7x02z88m594zymsg4kh73njq6q30k5656smjpym";
  };

  buildInputs = [python makeWrapper];

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/bzr --prefix PYTHONPATH : "$(toPythonPath $out)"
  '';

  meta = {
    homepage = http://bazaar-vcs.org/;
    description = "A distributed version control system that Just Works";
  };
}
