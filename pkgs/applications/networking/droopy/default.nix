{ stdenv, lib, fetchFromGitHub, wrapPython }:

with lib;

stdenv.mkDerivation rec {
  name = "droopy-${version}";
  version = "20160830";

  src = fetchFromGitHub {
    owner = "stackp";
    repo = "Droopy";
    rev = "7a9c7bc46c4ff8b743755be86a9b29bd1a8ba1d9";
    sha256 = "03i1arwyj9qpfyyvccl21lbpz3rnnp1hsadvc0b23nh1z2ng9sff";
  };

  nativeBuildInputs = [ wrapPython ];

  installPhase = ''
    install -vD droopy $out/bin/droopy
    install -vD -m 644 man/droopy.1 $out/share/man/man1/droopy.1
    wrapPythonPrograms
  '';

  meta = {
    description = "Mini Web server that let others upload files to your computer";
    homepage = http://stackp.online.fr/droopy;
    license = licenses.bsd3;
    maintainers = [ maintainers.profpatsch ];
  };

}
