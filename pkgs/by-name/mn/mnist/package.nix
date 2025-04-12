{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  srcs = {
    train-images = fetchurl {
      url = "http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz";
      sha256 = "029na81z5a1c9l1a8472dgshami6f2iixs3m2ji6ym6cffzwl3s4";
    };
    train-labels = fetchurl {
      url = "http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz";
      sha256 = "0p152200wwx0w65sqb65grb3v8ncjp230aykmvbbx2sm19556lim";
    };
    test-images = fetchurl {
      url = "http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz";
      sha256 = "1rn4vfigaxn2ms24bf4jwzzflgp3hvz0gksvb8j7j70w19xjqhld";
    };
    test-labels = fetchurl {
      url = "http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz";
      sha256 = "1imf0i194ndjxzxdx87zlgn728xx3p1qhq1ssbmnvv005vwn1bpp";
    };
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "mnist";
  version = "2018-11-16";
  installPhase = ''
    mkdir -p $out
    ln -s "${srcs.train-images}" "$out/${srcs.train-images.name}"
    ln -s "${srcs.train-labels}" "$out/${srcs.train-labels.name}"
    ln -s "${srcs.test-images}" "$out/${srcs.test-images.name}"
    ln -s "${srcs.test-labels}" "$out/${srcs.test-labels.name}"
  '';
  dontUnpack = true;
  meta = with lib; {
    description = "Large database of handwritten digits";
    longDescription = ''
      The MNIST database (Modified National Institute of Standards and
      Technology database) is a large database of handwritten digits that is
      commonly used for training various image processing systems.
    '';
    homepage = "http://yann.lecun.com/exdb/mnist/index.html";
    license = licenses.cc-by-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
