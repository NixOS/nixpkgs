{ lib
, stdenv
, fetchFromGitHub
, gmic
, gmic-qt
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cimg";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "CImg";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-Y3UPfBH+Sa1f529J1JXx8Ul0zi3b1mkOvo1tbxBSYRk=";
  };

  outputs = [ "out" "doc" ];

  installPhase = ''
    runHook preInstall

    install -dm 755 $out/include/CImg/plugins $doc/share/doc/cimg/examples
    install -m 644 CImg.h $out/include/
    cp -dr --no-preserve=ownership plugins/* $out/include/CImg/plugins/
    cp -dr --no-preserve=ownership examples/* $doc/share/doc/cimg/examples/
    cp README.txt $doc/share/doc/cimg/

    runHook postInstall
  '';

  passthru.tests = {
    # Needs to update them all in lockstep.
    inherit gmic gmic-qt;
  };

  meta = {
    homepage = "http://cimg.eu/";
    description = "A small, open source, C++ toolkit for image processing";
    longDescription = ''
      CImg stands for Cool Image. It is easy to use, efficient and is intended
      to be a very pleasant toolbox to design image processing algorithms in
      C++. Due to its generic conception, it can cover a wide range of image
      processing applications.
    '';
    license = lib.licenses.cecill-c;
    maintainers = [
      lib.maintainers.AndersonTorres
      lib.maintainers.lilyinstarlight
    ];
    platforms = lib.platforms.unix;
  };
})
