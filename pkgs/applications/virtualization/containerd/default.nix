{ stdenv, lib, fetchFromGitHub, buildGoPackage, btrfs-progs, go-md2man, utillinux }:

with lib;

buildGoPackage rec {
  name = "containerd-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "065snv0s3v3z0ghadlii4w78qnhchcbx2kfdrvm8fk8gb4pkx1ya";
  };

  goPackagePath = "github.com/containerd/containerd";
  outputs = [ "bin" "out" "man" ];

  hardeningDisable = [ "fortify" ];

  buildInputs = [ btrfs-progs go-md2man utillinux ];
  buildFlags = "VERSION=v${version}";

  BUILDTAGS = []
    ++ optional (btrfs-progs == null) "no_btrfs";

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    make binaries
  '';

  installPhase = ''
    for b in bin/*; do
      install -Dm555 $b $bin/$b
    done

    make man
    manRoot="$man/share/man"
    mkdir -p "$manRoot"
    for manFile in man/*; do
      manName="$(basename "$manFile")" # "docker-build.1"
      number="$(echo $manName | rev | cut -d'.' -f1 | rev)"
      mkdir -p "$manRoot/man$number"
      gzip -c "$manFile" > "$manRoot/man$number/$manName.gz"
    done
  '';

  meta = {
    homepage = https://containerd.io/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = platforms.linux;
  };
}
