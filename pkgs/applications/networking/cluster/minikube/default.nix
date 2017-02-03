{ stdenv, lib, fetchurl, makeWrapper, docker-machine-kvm, kubernetes, libvirt, qemu }:

let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "0njx4vzr0cpr3dba08w0jrlpfb8qrmxq5lqfrk3qrx29x5y6i6hi"
             else "0i21m1pys6rdxcwsk987l08lhzpcbg4bdrznaam02g6jj6jxvq0x";

# TODO: compile from source

in stdenv.mkDerivation rec {
  pname = "minikube";
  version = "0.16.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://storage.googleapis.com/minikube/releases/v${version}/minikube-${arch}";
    sha256 = "${checksum}";
  };

  phases = [ "installPhase" ];

  buildInputs = [ makeWrapper ];

  binPath = lib.makeBinPath [ docker-machine-kvm kubernetes libvirt qemu ];

  installPhase = ''
    install -Dm755 ${src} $out/bin/${pname}

    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${binPath}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry ];
    platforms = with platforms; linux ++ darwin;
  };
}
