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

let
  makeFlags = "BUILDTAGS=\"apparmor seccomp selinux
    containers_image_ostree_stub\"";
in buildGoPackage rec {
  project = "cri-o";
  version = "1.16.1";
  name = "${project}-${version}${flavor}";

  goPackagePath = "github.com/${project}/${project}";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "0w690zhc55gdqzc31jc34nrzwd253pfb3rq23z51q22nqwmlsh9p";
  };

  outputs = [ "bin" "out" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ btrfs-progs gpgme libapparmor libassuan libgpgerror
                 libseccomp libselinux lvm2 ]
                ++ stdenv.lib.optionals (glibc != null) [ glibc glibc.static ];

  buildPhase = ''
    pushd go/src/${goPackagePath}

    # Build pause
    make -C pause

    # Build the crio binaries
    function build() {
      go build \
        -tags ${makeFlags} \
        -o bin/"$1" \
        -buildmode=pie \
        -ldflags '-s -w ${ldflags}' \
        ${goPackagePath}/cmd/"$1"
    }
    build crio
    build crio-status
  '';
  installPhase = ''
    install -Dm755 bin/crio $bin/bin/crio${flavor}
    install -Dm755 bin/crio-status $bin/bin/crio-status${flavor}

    mkdir -p $bin/libexec/crio
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
