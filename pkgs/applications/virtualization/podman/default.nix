{ stdenv, lib, fetchFromGitHub, removeReferencesTo, pkgconfig
, go, gpgme, lvm2, btrfs-progs, libseccomp
}:

with lib;

stdenv.mkDerivation rec {
  name = "podman-${version}";
  version = "0.12.1.2";
  src = fetchFromGitHub {
    owner = "containers";
    repo = "libpod";
    rev = "v${version}";
    sha256 = "1gz7vci273bgrihrxbks2zxlb2lsmlj3lisw7s3d54ci0zr7avv3";
  };
  
  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];
  nativeBuildInputs = [ pkgconfig removeReferencesTo ];
  
  buildInputs = [
    go btrfs-progs libseccomp gpgme lvm2
  ];

  buildPhase = ''
    patchShebangs .
    mkdir -p .gopath/src/github.com/containers
    ln -sf $PWD .gopath/src/github.com/containers/libpod
    ln -sf $PWD/vendor/github.com/varlink .gopath/src/github.com/varlink
    export GOPATH="$PWD/.gopath:$GOPATH"
    make binaries
  '';
  
  installPhase = ''
    install -Dm555 bin/podman $out/bin/podman
  '';
  
  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} -t ${stdenv.cc.cc} -t ${stdenv.glibc.dev} '{}' +
  '';

  meta = {
    homepage = https://podman.io/;
    description = "A program for managing pods, containers and container images";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
    platforms = platforms.linux;
  };
}
