{ lib, fetchFromGitHub, buildGoPackage, btrfs-progs, go-md2man, installShellFiles, utillinux }:

with lib;

buildGoPackage rec {
  pname = "containerd";
  version = "1.4.1";
  # git commit for the above version's tag
  commit = "7ad184331fa3e55e52b890ea95e65ba581ae3429";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "1k6dqaidnldf7kpxdszf0wn6xb8m6vaizm2aza81fri1q0051213";
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

  meta = {
    homepage = "https://containerd.io/";
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = platforms.linux;
  };
}
