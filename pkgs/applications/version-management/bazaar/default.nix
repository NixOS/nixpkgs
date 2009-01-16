{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "bazaar-1.10rc1";

  src = fetchurl {
    url = http://launchpad.net/bzr/1.10/1.10rc1/+download/bzr-1.10rc1.tar.gz;
    sha256 = "dc3669e15ced93e0956c13b724f604075e0323ce07fb08f6463946c85e69bec0";
  };

  buildInputs = [python makeWrapper];

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/bzr --prefix PYTHONPATH : "$(toPythonPath $out)"
  '';

  passthru = {
    # If someone wants to assert python features..
    inherit python;
  };

  meta = {
    homepage = http://bazaar-vcs.org/;
    description = "A distributed version control system that Just Works";
  };

}
