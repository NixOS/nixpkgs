{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, pkgconfig, minikube }:

buildGoPackage rec {
  pname = "docker-machine-kvm2";
  name = "${pname}-${version}";
  version = minikube.version;

  goPackagePath = "k8s.io/minikube";
  subPackages = [ "cmd/drivers/kvm" ];

  src = minikube.src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvirt ];

  preBuild = ''
    export buildFlagsArray=(-ldflags="-X k8s.io/minikube/pkg/drivers/kvm/version.VERSION=v${version}")
  '';

  postInstall = ''
    mv $bin/bin/kvm $bin/bin/docker-machine-driver-kvm2
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/minikube/blob/master/docs/drivers.md;
    description = "KVM2 driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.unix;
  };
}
