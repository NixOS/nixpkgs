{ stdenv, fetchFromGitHub, pkgconfig
, buildGoPackage, gpgme, lvm2, btrfs-progs, libseccomp, systemd
, go-md2man
}:

buildGoPackage rec {
  name = "podman-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "libpod";
    rev    = "v${version}";
    sha256 = "1gb51byff1140hhp8w771953jxfcwvld1ynyh52xy4hl2d933s3l";
  };

  goPackagePath = "github.com/containers/libpod";

  outputs = [ "bin" "out" "man" ];

  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];
  nativeBuildInputs = [ pkgconfig go-md2man ];

  buildInputs = [ btrfs-progs libseccomp gpgme lvm2 systemd ];

  buildPhase = ''
    pushd $NIX_BUILD_TOP/go/src/${goPackagePath}
    patchShebangs .
    make binaries docs
  '';

  installPhase = ''
    install -Dm555 bin/podman $bin/bin/podman
    MANDIR=$man/share/man make install.man
  '';

  meta = with stdenv.lib; {
    homepage = https://podman.io/;
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
    platforms = platforms.linux;
  };
}
