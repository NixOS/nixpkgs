{ stdenv, lib, fetchFromGitHub, buildGoPackage, libvirt }:

with lib;

buildGoPackage rec {
  name = "runv-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hyperhq";
    repo = "runv";
    rev = "v${version}";
    sha256 = "0dw1li834jjda8hqry9jvpks5703ss0m930sqpvqlzwx4adwwghp";
  };

  buildInputs = [ libvirt ];

  goPackagePath = "github.com/hyperhq/runv";

  buildPhase = ''
    go install -p $NIX_BUILD_CORES -tags "static_build with_libvirt" -v $goPackagePath/cli
  '';

  # The binary is called cli because of the package name, so rename it to runv
  postInstall = ''
    mv $bin/bin/cli $bin/bin/runv
  '';

  meta = {
    homepage = https://github.com/hyperhq/runv;
    description = "Hypervisor-based Runtime for OCI";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.linux;
  };
}
