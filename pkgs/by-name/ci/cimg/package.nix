{ lib
, stdenv
, fetchFromGitHub
, gmic
, gmic-qt
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cimg";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "CImg";
    rev = "refs/tags/v.${finalAttrs.version}";
    hash = "sha256-lYs8V/phdyM1kpcxBDS3vAjxFgGCaaOCdNHU3//dgDs=";
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
    description = "Small, open source, C++ toolkit for image processing";
    longDescription = ''
      CImg stands for Cool Image. It is easy to use, efficient and is intended
      to be a very pleasant toolbox to design image processing algorithms in
      C++. Due to its generic conception, it can cover a wide range of image
      processing applications.
    '';
    license = lib.licenses.cecill-c;
    maintainers = [
      lib.maintainers.AndersonTorres
    ];
    platforms = lib.platforms.unix;
  };
})
