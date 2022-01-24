{ lib, fetchFromGitHub, fetchurl, python2Packages, curl }:

let
  getmodel = name: sha256: {
    inherit name;
    src = fetchurl {
      url = "http://www.tmbdev.net/ocropy/${name}";
      inherit sha256;
    };
  };

  models = [
    (getmodel "en-default.pyrnn.gz"
      "1xyi3k3p81mfw0491gb1haisazfyi2i18f1wjs1m34ak39qfqjdp")
    (getmodel "fraktur.pyrnn.gz"
      "1wlwvxn91ilgmlri1hj81arl3mbzxc24ycdnkf5icq4hdi4c6y8b")
  ];

in
python2Packages.buildPythonApplication rec {
  pname = "ocropus";
  version = "1.3.3";

  src = fetchFromGitHub {
    sha256 = "02p1334mic5cfhvpfphfrbim4036yfd8s2zzpwm0xmm829z71nr7";
    rev = "v${version}";
    repo = "ocropy";
    owner = "tmbdev";
  };

  propagatedBuildInputs = with python2Packages; [ curl numpy scipy pillow
    matplotlib beautifulsoup4 pygtk lxml ];

  enableParallelBuilding = true;

  preConfigure = with lib; ''
    ${concatStrings (map (x: "cp -R ${x.src} models/`basename ${x.name}`;")
      models)}

    substituteInPlace ocrolib/common.py --replace /usr/local $out
    substituteInPlace ocrolib/default.py --replace /usr/local $out
  '';

  doCheck = false;  # fails
  checkPhase = ''
    patchShebangs .
    substituteInPlace ./run-test \
      --replace 'ocropus-rpred' 'ocropus-rpred -Q $NIX_BUILD_CORES'
    PATH=".:$PATH" ./run-test
  '';

  meta = with lib; {
    description = "Open source document analysis and OCR system";
    license = licenses.asl20;
    homepage = "https://github.com/tmbdev/ocropy/";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.linux;
  };
}
