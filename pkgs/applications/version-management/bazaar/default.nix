{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  version = "2.2";
  release = ".0";
  name = "bazaar-${version}${release}";

  src = fetchurl {
    url = "http://launchpad.net/bzr/${version}/${version}${release}/+download/bzr-${version}${release}.tar.gz";
    sha256 = "64cd6c23097884e40686adc7f0ad4a8200e2292bdc5e0caba3563b6f5c32bacf";
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
