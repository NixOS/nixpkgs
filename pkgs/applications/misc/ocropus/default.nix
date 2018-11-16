{ stdenv, fetchFromGitHub, fetchurl, pythonPackages, curl }:

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
pythonPackages.buildPythonApplication rec {
  name = "ocropus-${version}";
  version = "20170811";

  src = fetchFromGitHub {
    sha256 = "0qx0d8yj0w66qglkrmfavp5dh1sky72njfaqii7bnrpv5n4j3q39";
    rev = "ae84a8edaf0b76135f749ba66fc30c272d0726d0";
    repo = "ocropy";
    owner = "tmbdev";
  };

  propagatedBuildInputs = with pythonPackages; [ curl numpy scipy pillow
    matplotlib beautifulsoup4 pygtk lxml ];

  enableParallelBuilding = true;

  preConfigure = with stdenv.lib; ''
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

  meta = with stdenv.lib; {
    description = "Open source document analysis and OCR system";
    license = licenses.asl20;
    homepage = https://github.com/tmbdev/ocropy/;
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.linux;
  };
}
