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
  version = "20150316";

  src = fetchFromGitHub {
    sha256 = "0m5bm2ah3p29c13vp7hz7rm058qnlm840zd8xv20byijhlz0447g";
    rev = "5ba07bb959d605ec15424dd2b8f3d7245820084e";
    repo = "ocropy";
    owner = "tmbdev";
  };

  propagatedBuildInputs = with pythonPackages; [ curl numpy scipy pillow
    matplotlib beautifulsoup4 pygtk lxml ];

  enableParallelBuilding = true;

  preConfigure = with stdenv.lib; ''
    ${concatStrings (map (x: "cp -R ${x.src} models/`basename ${x.name}`;")
      models)}

    substituteInPlace ocrolib/{common,default}.py --replace /usr/local $out
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
    maintainers = with maintainers; [ domenkozar nckx viric ];
    platforms = platforms.linux;
  };
}
