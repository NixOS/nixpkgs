{ stdenv, lib, go, fetchzip, git, fetchpatch, fetchFromGitHub, fetchgit }:

# When perkeep is updated all deps in the let block should be removed
let
  gopherjs = fetchFromGitHub {
    owner = "gopherjs";
    repo = "gopherjs";
    # Rev matching https://github.com/perkeep/perkeep/commit/2e46fca5cc1179dbd90bec49fec3870e6eca6c45
    rev = "b40cd48c38f9a18eb3db20d163bad78de12cf0b7";
    sha256 = "0kniz8dg5bymb03qriizza1h3gpymf97vsgq9vd222282pdj0vyc";
  };

  gotool = fetchFromGitHub {
    owner = "kisielk";
    repo = "gotool";
    rev = "80517062f582ea3340cd4baf70e86d539ae7d84d";
    sha256 = "14af2pa0ssyp8bp2mvdw184s5wcysk6akil3wzxmr05wwy951iwn";
  };

  gcimporter15 = fetchgit {
    url = "https://go.googlesource.com/tools";
    rev = "f8f2f88271bf2c23f28a09d288d26507a9503c97";
    sha256 = "1pchwizx1sdli59g8r0p4djfjkchcvh8msfpp3ibvz3xl250jh0n";
  };

in
stdenv.mkDerivation rec {
  name = "perkeep-${version}";
  version = "20170505";

  src = fetchzip {
    url = "https://perkeep.org/dl/monthly/camlistore-${version}-src.zip";
    sha256 = "1vliyvkyzmhdi6knbh8rdsswmz3h0rpxdpq037jwbdbkjccxjdwa";
  };

  # When perkeep is updated postPatch should be removed
  postPatch = ''
    rm -r ./vendor/github.com/gopherjs/gopherjs/
    cp -a ${gopherjs} ./vendor/github.com/gopherjs/gopherjs
    mkdir -p ./vendor/github.com/kisielk/
    cp -a ${gotool} ./vendor/github.com/kisielk/gotool
    mkdir -p ./vendor/golang.org/x/tools/go
    cp -a ${gcimporter15}/go/gcimporter15 ./vendor/golang.org/x/tools/go/gcimporter15

    substituteInPlace vendor/github.com/gopherjs/gopherjs/build/build.go \
      --replace '"github.com/fsnotify/fsnotify"' 'fsnotify "camlistore.org/pkg/misc/fakefsnotify"'

    substituteInPlace ./make.go \
      --replace "goVersionMinor  = '8'" "goVersionMinor  = '9'" \
      --replace "gopherJSGoMinor = '8'" "gopherJSGoMinor = '9'"
  '';

  buildInputs = [ git go ];

  goPackagePath = "";
  buildPhase = ''
    go run make.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = https://perkeep.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
