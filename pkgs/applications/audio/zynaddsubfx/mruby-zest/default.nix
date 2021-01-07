{ stdenv
, fetchFromGitHub
, bison
, git
, python2
, rake
, ruby
, libGL
, libuv
, libX11
}:

let
  mgem-list = fetchFromGitHub {
    owner = "mruby";
    repo = "mgem-list";
    rev = "2033837203c8a141b1f9d23bb781fe0cbaefbd24";
    sha256 = "0igf2nsx5i6g0yf7sjxxkngyriv213d0sjs3yidrflrabiywpxmm";
  };

  mruby-dir = fetchFromGitHub {
    owner = "iij";
    repo = "mruby-dir";
    rev = "89dceefa1250fb1ae868d4cb52498e9e24293cd1";
    sha256 = "0zrhiy9wmwmc9ls62iyb2z86j2ijqfn7rn4xfmrbrfxygczarsm9";
  };

  mruby-errno = fetchFromGitHub {
    owner = "iij";
    repo = "mruby-errno";
    rev = "b4415207ff6ea62360619c89a1cff83259dc4db0";
    sha256 = "12djcwjjw0fygai5kssxbfs3pzh3cpnq07h9m2h5b51jziw380xj";
  };

  mruby-file-stat = fetchFromGitHub {
    owner = "ksss";
    repo = "mruby-file-stat";
    rev = "aa474589f065c71d9e39ab8ba976f3bea6f9aac2";
    sha256 = "1clarmr67z133ivkbwla1a42wcjgj638j9w0mlv5n21mhim9rid5";
  };

  mruby-process = fetchFromGitHub {
    owner = "iij";
    repo = "mruby-process";
    rev = "fe171fbe2a6cc3c2cf7d713641bddde71024f7c8";
    sha256 = "00yrzc371f90gl5m1gbkw0qq8c394bpifssjr8p1wh5fmzhxqyml";
  };

  mruby-pack = fetchFromGitHub {
    owner = "iij";
    repo = "mruby-pack";
    rev = "383a9c79e191d524a9a2b4107cc5043ecbf6190b";
    sha256 = "003glxgxifk4ixl12sy4gn9bhwvgb79b4wga549ic79isgv81w2d";
  };
in
stdenv.mkDerivation rec {
  pname = "mruby-zest";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-build";
    rev = version;
    sha256 = "0fxljrgamgz2rm85mclixs00b0f2yf109jc369039n1vf0l5m57d";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ bison git python2 rake ruby ];
  buildInputs = [ libGL libuv libX11 ];

  patches = [
    ./force-gcc-as-linker.patch
    ./system-libuv.patch
  ];

  # Add missing dependencies of deps/mruby-dir-glob/mrbgem.rake
  # Should be fixed in next release, see bcadb0a5490bd6d599f1a0e66ce09b46363c9dae
  postPatch = ''
    mkdir -p mruby/build/mrbgems
    ln -s ${mgem-list} mruby/build/mrbgems/mgem-list
    ln -s ${mruby-dir} mruby/build/mrbgems/mruby-dir
    ln -s ${mruby-errno} mruby/build/mrbgems/mruby-errno
    ln -s ${mruby-file-stat} mruby/build/mrbgems/mruby-file-stat
    ln -s ${mruby-process} mruby/build/mrbgems/mruby-process
    ln -s ${mruby-pack} mruby/build/mrbgems/mruby-pack
  '';

  installTargets = [ "pack" ];

  postInstall = ''
    ln -s "$out/zest" "$out/zyn-fusion"
    cp -a package/{font,libzest.so,schema,zest} "$out"

    # mruby-widget-lib/src/api.c requires MainWindow.qml as part of a
    # sanity check, even though qml files are compiled into the binary
    # https://github.com/mruby-zest/mruby-zest-build/tree/3.0.5/src/mruby-widget-lib/src/api.c#L99-L116
    # https://github.com/mruby-zest/mruby-zest-build/tree/3.0.5/linux-pack.sh#L17-L18
    mkdir -p "$out/qml"
    touch "$out/qml/MainWindow.qml"
  '';

  meta = with stdenv.lib; {
    description = "The Zest Framework used in ZynAddSubFX's UI";
    homepage = "https://github.com/mruby-zest";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.all;
  };
}
