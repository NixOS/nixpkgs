{ stdenv, lib, fetchFromGitHub, wrapPython, fetchpatch }:

stdenv.mkDerivation {
  pname = "droopy";
  version = "20160830";

  src = fetchFromGitHub {
    owner = "stackp";
    repo = "Droopy";
    rev = "7a9c7bc46c4ff8b743755be86a9b29bd1a8ba1d9";
    sha256 = "03i1arwyj9qpfyyvccl21lbpz3rnnp1hsadvc0b23nh1z2ng9sff";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/stackp/Droopy/pull/30.patch";
      sha256 = "Y6jBraKvVQAiScbvLwezSKeWY3vaAbhaNXEGNaItigQ=";
    })
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/stackp/Droopy/pull/31.patch";
      sha256 = "1ig054rxn5r0ph4w4fhmrxlh158c97iqqc7dbnc819adn9nw96l5";
    })
  ];

  nativeBuildInputs = [ wrapPython ];

  installPhase = ''
    install -vD droopy $out/bin/droopy
    install -vD -m 644 man/droopy.1 $out/share/man/man1/droopy.1
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Mini Web server that let others upload files to your computer";
    homepage = "http://stackp.online.fr/droopy";
    license = licenses.bsd3;
    maintainers = [ maintainers.Profpatsch ];
    mainProgram = "droopy";
  };

}
