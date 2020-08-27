{ stdenv, fetchFromGitHub, requireFile, unzip, cmake }:

stdenv.mkDerivation rec {
  name = "airwindows-${version}";
  version = "2020-08-24";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "3022096e8c0e82abdefbc7cae240dd8d0cac5147";
    sha256 = "1pvnzl486630qhdc6qjgddglgq89lxjh2kgnyl4q2ia9mn36iisx";
  };

  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk366_27_06_2016_build_61";
    src = requireFile {
      name = "${name}.zip";
      url = "https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip";
      sha256 = "05gsr13bpi2hhp34rvhllsvmn44rqvmjdpg9fsgfzgylfkz0kiki";
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
    cp -r ${vst-sdk}/pluginterfaces include/vstsdk/pluginterfaces
    cp -r ${vst-sdk}/public.sdk/source/vst2.x/* include/vstsdk/
    chmod -R 777 include/vstsdk/pluginterfaces
  '';

  installPhase = ''
    for so_file in *.so; do
      install -vDm 644 $so_file -t "$out/lib/lxvst"
    done;
  '';

  meta = with stdenv.lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = http://www.airwindows.com/airwindows-linux/;
    # airwindows is mit, but the vst sdk is unfree
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
