{ stdenv, fetchFromGitHub, requireFile, unzip, cmake }:

stdenv.mkDerivation rec {
  name = "airwindows-${version}";
  version = "20-08-2018";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "2384d83b0fe4f455722e47df9315885ba3c74011";
    sha256 = "1f52zvcva1cy8y6hsqdjqa4vgg9k7b4spbvdq2ggk9cmdlnl2vgh";
  };

  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk3610_11_06_2018_build_37";
    src = requireFile {
      name = "${name}.zip";
      url = "http://www.steinberg.net/en/company/developers.html";
      sha256 = "176lr4gadgdnvv56q19amf533g5wbgvq4s28fi0zldjnjl1iwp9y";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = "cp -r . $out";
  };

  airwindows-ports = stdenv.mkDerivation rec {
    name = "airwindows-ports";
    src = fetchFromGitHub {
      owner = "ech2";
      repo = "airwindows-ports";
      rev = "0.4.0";
      sha256 = "1ya4qbc63sb52nzisdapsydrnnpqnjsl5kgxibbr3dxf32474g89";
    };
    installPhase = "cp -r . $out";
  };

  nativeBuildInputs = [ cmake ];

  patchPhase = ''
    cd plugins/LinuxVST
    rm build/CMakeCache.txt
    mkdir -p include/vstsdk
    cp -r ${airwindows-ports}/include/vstsdk/CMakeLists.txt include/vstsdk/
    cp -r ${vst-sdk}/VST2_SDK/pluginterfaces include/vstsdk/pluginterfaces
    cp -r ${vst-sdk}/VST2_SDK/public.sdk/source/vst2.x/* include/vstsdk/
  '';

  installPhase = ''
    mkdir -p $out/lib/lxvst
    cp *.so $out/lib/lxvst
  '';

  meta = with stdenv.lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = http://www.airwindows.com/airwindows-linux/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
