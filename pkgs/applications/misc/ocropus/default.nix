{ stdenv, fetchhg, fetchurl, pythonPackages, curl }:

let
  getmodel = name: sha256: {
    src = fetchurl {
      url = "http://iupr1.cs.uni-kl.de/~tmb/ocropus-models/${name}";
      inherit sha256;
    };
    inherit name;
  };

  models = [
    (getmodel "en-default.pyrnn.gz"
      "1xyi3k3p81mfw0491gb1haisazfyi2i18f1wjs1m34ak39qfqjdp")
    (getmodel "en-uw3-linerel-2.cmodel.gz"
      "0zdw0db2znxxd4h7aa09506nkbxd1cfqacxzyzlx42bjn951wcpw")
    (getmodel "en-mixed-3.ngraphs.gz"
      "1fqw7pxmjwapirp9xv3b0gn9pk53q4740qn5dw4wxfxk9dpp9lr4")
    (getmodel "en-space.model.gz"
      "0w5hnjm6rz5iiw1p2yixj147ifq11s9jfzrxk4v4xxmcyn365096")
    (getmodel "en-mixed.lineest.gz"
      "0skrziksn3zb3g8588y7jd10pnl2pzrby0119ac0awapzzg9vkvw")
    (getmodel "uw3unlv.pyrnn.gz"
      "0g08q9cjxxx3mg1jn4654nalxr56y2jq1h33pwxrj5lrckr7grb9")
    (getmodel "en-uw3unlv-perchar.cmodel.gz"
      "1izvm0wkb2vh58hjp59fw97drv17zdzrw6mz3aanrg5ax6fnfadk")
    (getmodel "gradient.lineest.gz"
      "1bw9hj9byjxi31rjh2xiysnx8c72jz0npxa54xgjwsqg7ihl8jzw")
    (getmodel "en-mixed-round1.lineest.gz"
      "1fjkygyrg4ng7kx4iqa4yhgvmw1zq72p3q5p0hcb2xxhqc04vx7c")
    (getmodel "frakant.pyrnn.gz"
      "0i1k95f2a8qlc6m7qq11pmjfcimyrjsfjvv20nrs2ygp9pwskmxp")
    (getmodel "fraktur.pyrnn.gz"
      "1wlwvxn91ilgmlri1hj81arl3mbzxc24ycdnkf5icq4hdi4c6y8b")
  ];
in
pythonPackages.buildPythonPackage rec {
  name = "ocropus-${version}";
  version = "20130905";

  src = fetchhg {
    url = "https://code.google.com/p/ocropus.ocropy";
    tag = "a6e0fbd820ce";
    sha256 = "1s0v0gd6psfjp6lghwl2dj49h18mgf2n2z8hqzw8430nzhglnlvr";
  };

  patches = [ ./display.patch ];

  propagatedBuildInputs = with pythonPackages; [ curl numpy scipy pillow
    matplotlib beautifulsoup4 pygtk lxml ];

  enableParallelBuilding = true;
  
  preConfigure = with stdenv.lib; ''
    ${concatStrings (map (x: "ln -s ${x.src} models/${x.name};") models)}

    sed -i 's|/usr/local|'$out'|' ocrolib/common.py
    sed -i 's|/usr/local|'$out'|' ocrolib/default.py
    ${pythonPackages.python}/bin/${pythonPackages.python.executable} setup.py download_models
  '';

  meta = with stdenv.lib; {
    description = "Open source document analysis and OCR system";
    license = licenses.asl20;
    homepage = https://code.google.com/p/ocropus/;
    maintainers = with maintainers; [ iElectric viric ];
    platforms = platforms.linux;
  };
}
