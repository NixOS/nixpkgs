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

let
  buildTags = "apparmor seccomp selinux containers_image_ostree_stub";
in buildGoPackage rec {
  project = "cri-o";
  version = "1.17.0";
  name = "${project}-${version}${flavor}";

  goPackagePath = "github.com/${project}/${project}";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "0xjmylf0ww23qqcg7kw008px6608r4qq6q57pfqis0661kp6f24j";
  };

  outputs = [ "bin" "out" ];
  nativeBuildInputs = [ git pkgconfig which ];
  buildInputs = [ btrfs-progs gpgme libapparmor libassuan libgpgerror
                 libseccomp libselinux lvm2 ]
                ++ stdenv.lib.optionals (glibc != null) [ glibc glibc.static ];

  buildPhase = ''
    pushd go/src/${goPackagePath}

    make BUILDTAGS='${buildTags}' \
      bin/crio \
      bin/crio-status \
      bin/pinns
  '';
  installPhase = ''
    install -Dm755 bin/crio $bin/bin/crio${flavor}
    install -Dm755 bin/crio-status $bin/bin/crio-status${flavor}
    install -Dm755 bin/pinns $bin/bin/pinns${flavor}
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
