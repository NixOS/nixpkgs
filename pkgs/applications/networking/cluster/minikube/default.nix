{ stdenv, lib, fetchurl, makeWrapper, docker-machine-kvm, kubernetes, libvirt, qemu }:

let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "0cdcabsx5l4jbpyj3zzyz5bnzks6wl64bmzdsnk41x92ar5y5yal"
             else "12f3b7s5lwpvzx4wj6i6h62n4zjshqf206fxxwpwx9kpsdaw6xdi";

# TODO: compile from source

in stdenv.mkDerivation rec {
  pname = "minikube";
  version = "0.17.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://storage.googleapis.com/minikube/releases/v${version}/minikube-${arch}";
    sha256 = "${checksum}";
  };

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ makeWrapper ];

  binPath = lib.makeBinPath [ docker-machine-kvm kubernetes libvirt qemu ];

  installPhase = ''
    install -Dm755 ${src} $out/bin/${pname}
  '';

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/minikube"

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
