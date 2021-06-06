{ lib, fetchFromGitHub, buildGoPackage, btrfs-progs, go-md2man, installShellFiles, utillinux, nixosTests }:

with lib;

buildGoPackage rec {
  pname = "containerd";
  version = "1.4.6";
  # git commit for the above version's tag
  commit = "d71fcd7d8303cbf684402823e425e9dd2e99285d";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "1an4gzg7fz24nq7vb3k8ddv5r0s98x88mz0z67197brsmi4pwy58";
  };

  goPackagePath = "github.com/containerd/containerd";
  outputs = [ "out" "man" ];

  nativeBuildInputs = [ go-md2man installShellFiles utillinux ];

  buildInputs = [ btrfs-progs ];

  buildFlags = [ "VERSION=v${version}" "REVISION=${commit}" ];

  BUILDTAGS = []
    ++ optional (btrfs-progs == null) "no_btrfs";

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    make binaries $buildFlags
  '';

  installPhase = ''
    for b in bin/*; do
      install -Dm555 $b $out/$b
    done

    make man
    installManPage man/*.[1-9]
  '';

  passthru.tests = { inherit (nixosTests) docker; };

  meta = {
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = platforms.linux;
  };
}
