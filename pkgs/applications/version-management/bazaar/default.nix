{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "bazaar-1.1";

  src = fetchurl {
    url = https://launchpad.net/bzr/1.1/1.1/+download/bzr-1.1.tar.gz;
    sha256 = "1qpkw580r22yxybdghx2ha0kyk22brbhd1kg9wwjh209dqy2gqzc";
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
