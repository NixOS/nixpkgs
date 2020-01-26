{ stdenv, fetchFromGitHub, pkgconfig, installShellFiles
, buildGoPackage, gpgme, lvm2, btrfs-progs, libseccomp, systemd
, go-md2man
}:

buildGoPackage rec {
  pname = "podman";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "libpod";
    rev    = "v${version}";
    sha256 = "1f1dq9g08mlm9y9d7jbs780nrfc25ln97ca5qifcsyc9bmp4f6r1";
  };

  goPackagePath = "github.com/containers/libpod";

  outputs = [ "bin" "out" "man" ];

  nativeBuildInputs = [ pkgconfig go-md2man installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ btrfs-progs libseccomp gpgme lvm2 systemd ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    patchShebangs .
    ${if stdenv.isDarwin
      then "make CGO_ENABLED=0 BUILDTAGS='remoteclient containers_image_openpgp exclude_graphdriver_devicemapper' varlink_generate all"
      else "make binaries docs"}
  '';

  installPhase = ''
    install -Dm555 bin/podman $bin/bin/podman
    installShellCompletion --bash completions/bash/podman
    installShellCompletion --zsh completions/zsh/_podman
    MANDIR=$man/share/man make install.man
  '';

  meta = with stdenv.lib; {
    homepage = https://podman.io/;
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester saschagrunert marsam ];
    platforms = platforms.unix;
  };
}
