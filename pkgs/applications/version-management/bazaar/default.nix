{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "bazaar-1.5";

  src = fetchurl {
    url = http://launchpad.net/bzr/1.5/1.5/+download/bzr-1.5.tar.gz;
    sha256 = "0wacjmnil5pivkcqz3jcqfqh258yrwv33fg2p8vf45pbmr7yw0bv";
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
