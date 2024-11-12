{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "migmix";
  version = "20150712";

  srcs = [
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-1p-${version}.zip";
      sha256 = "0wp44axcalaak04nj3dgpx0vk13nqa3ihx2vjv4acsgv83x8ciph";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-2p-${version}.zip";
      sha256 = "0y7s3rbxrp5bv56qgihk8b847lqgibfhn2wlkzx7z655fbzdgxw9";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-1m-${version}.zip";
      sha256 = "1sfym0chy8ilyd9sr3mjc0bf63vc33p05ynpdc11miivxn4qsshx";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63544/migmix-2m-${version}.zip";
      sha256 = "0hg04rvm39fh4my4akmv4rhfc14s3ipz2aw718h505k9hppkhkch";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    find $srcs -name '*.ttf' -exec install -m644 -Dt $out/share/fonts/truetype/migmix {} \;
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1fhh8wg6lxwrnsg9rl4ihffl0bsp1wqa5gps9fx60kr6j9wpvmbg";

  meta = with lib; {
    description = "High-quality Japanese font based on M+ fonts and IPA fonts";
    homepage = "http://mix-mplus-ipa.osdn.jp/migmix";
    license = licenses.ipa;
    maintainers = [ maintainers.mikoim ];
  };
}
