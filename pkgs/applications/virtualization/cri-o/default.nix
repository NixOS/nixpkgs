{ flavor ? ""
, ldflags ? ""
, stdenv
, btrfs-progs
, buildGoPackage
, fetchFromGitHub
, glibc
, gpgme
, libapparmor
, libassuan
, libgpgerror
, libseccomp
, libselinux
, lvm2
, pkgconfig
}:

buildGoPackage rec {
  project = "cri-o";
  version = "1.14.1";
  name = "${project}-${version}${flavor}";

  goPackagePath = "github.com/${project}/${project}";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "1cclxarwabk5zlqysm2dzgsm6qkxyzbnlylr0gs57ppn4ibky3nk";
  };

  outputs = [ "bin" "out" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ btrfs-progs gpgme libapparmor libassuan libgpgerror
                 libseccomp libselinux lvm2 ]
                ++ stdenv.lib.optionals (glibc != null) [ glibc glibc.static ];

  makeFlags = ''BUILDTAGS="apparmor seccomp selinux
    containers_image_ostree_stub"'';

  buildPhase = ''
    pushd go/src/${goPackagePath}

    # Build conmon and pause
    go build -tags ${makeFlags} -o bin/crio-config -buildmode=pie \
      -ldflags '-s -w ${ldflags}' ${goPackagePath}/cmd/crio-config

    pushd conmon
    ../bin/crio-config
    popd

    make -C conmon
    make -C pause

    # Build the crio binary
    go build -tags ${makeFlags} -o bin/crio -buildmode=pie \
      -ldflags '-s -w ${ldflags}' ${goPackagePath}/cmd/crio
  '';
  installPhase = ''
    install -Dm755 bin/crio $bin/bin/crio${flavor}

    mkdir -p $bin/libexec/crio
    install -Dm755 bin/conmon $bin/libexec/crio/conmon${flavor}
    install -Dm755 bin/pause $bin/libexec/crio/pause${flavor}
  '';

  meta = with stdenv.lib; {
    homepage = https://cri-o.io;
    description = ''Open Container Initiative-based implementation of the
                    Kubernetes Container Runtime Interface'';
    license = licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
