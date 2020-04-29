{ flavor ? ""
, stdenv
, btrfs-progs
, buildGoPackage
, fetchFromGitHub
, git
, glibc
, gpgme
, libapparmor
, libassuan
, libgpgerror
, libseccomp
, libselinux
, lvm2
, pkgconfig
, which
}:

buildGoPackage rec {
  project = "cri-o";
  version = "1.18.0";
  name = "${project}-${version}${flavor}";

  goPackagePath = "github.com/${project}/${project}";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "142flmv54pj48rjqkd26fbxrcbx2cv6pdmrc33jgyvn6r99zliah";
  };

  nativeBuildInputs = [ git pkgconfig which ];
  buildInputs = [ btrfs-progs gpgme libapparmor libassuan libgpgerror
                 libseccomp libselinux lvm2 ]
                ++ stdenv.lib.optionals (glibc != null) [ glibc glibc.static ];

  BUILDTAGS = "apparmor seccomp selinux containers_image_ostree_stub";
  buildPhase = ''
    pushd go/src/${goPackagePath}

    make binaries BUILDTAGS="$BUILDTAGS"
  '';
  installPhase = ''
    install -Dm755 bin/crio $out/bin/crio${flavor}
    install -Dm755 bin/crio-status $out/bin/crio-status${flavor}
    install -Dm755 bin/pinns $out/bin/pinns${flavor}
  '';

  meta = with stdenv.lib; {
    homepage = "https://cri-o.io";
    description = ''Open Container Initiative-based implementation of the
                    Kubernetes Container Runtime Interface'';
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
