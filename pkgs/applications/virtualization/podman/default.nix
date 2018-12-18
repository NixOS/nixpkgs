{ stdenv, fetchFromGitHub, pkgconfig
, buildGoPackage, gpgme, lvm2, btrfs-progs, libseccomp
}:

buildGoPackage rec {
  name = "podman-${version}";
  version = "0.12.1.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libpod";
    rev = "v${version}";
    sha256 = "1gz7vci273bgrihrxbks2zxlb2lsmlj3lisw7s3d54ci0zr7avv3";
  };

  goPackagePath = "github.com/containers/libpod";

  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];
  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    btrfs-progs libseccomp gpgme lvm2
  ];

  buildPhase = ''
    pushd $NIX_BUILD_TOP/go/src/${goPackagePath}
    patchShebangs .
    make binaries
  '';

  installPhase = ''
    install -Dm555 bin/podman $bin/bin/podman
  '';

  meta = with stdenv.lib; {
    homepage = https://podman.io/;
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
    platforms = platforms.linux;
  };
}
