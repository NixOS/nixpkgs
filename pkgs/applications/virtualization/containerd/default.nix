{ lib, fetchFromGitHub, buildGoPackage, btrfs-progs, go-md2man, installShellFiles, util-linux, nixosTests }:

with lib;

buildGoPackage rec {
  pname = "containerd";
  version = "1.4.3";
  # git commit for the above version's tag
  commit = "269548fa27e0089a8b8278fc4fc781d7f65a939b";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "09xvhjg5f8h90w1y94kqqnqzhbhd62dcdd9wb9sdqakisjk6zrl0";
  };

  goPackagePath = "github.com/containerd/containerd";
  outputs = [ "out" "man" ];

  nativeBuildInputs = [ go-md2man installShellFiles util-linux ];

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
