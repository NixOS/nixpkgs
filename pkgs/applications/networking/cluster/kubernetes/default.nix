{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables, rsync, utillinux, coreutils, e2fsprogs, procps-ng }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "0w0f9chmrvkqrrsd5cdf3cwgcybw4472rfmwv0xq2v74lgd89mmm";
  };

  buildInputs = [ makeWrapper which go iptables rsync ];

  buildPhase = ''
    GOPATH=$(pwd):$(pwd)/Godeps/_workspace
    mkdir -p $(pwd)/Godeps/_workspace/src/k8s.io
    ln -s $(pwd) $(pwd)/Godeps/_workspace/src/k8s.io/kubernetes

    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    patchShebangs ./hack

    hack/build-go.sh --use_go_build
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out"/libexec/kubernetes/cluster
    cp _output/local/go/bin/{kube*,hyperkube} "$out/bin/"
    cp cluster/saltbase/salt/helpers/safe_format_and_mount "$out/libexec/kubernetes"
    cp -R hack "$out/libexec/kubernetes"
    cp cluster/update-storage-objects.sh "$out/libexec/kubernetes/cluster"
    makeWrapper "$out"/libexec/kubernetes/cluster/update-storage-objects.sh "$out"/bin/kube-update-storage-objects \
      --prefix KUBE_BIN : "$out/bin"
  '';

  preFixup = ''
    wrapProgram "$out/bin/kube-proxy" --prefix PATH : "${iptables}/bin"
    wrapProgram "$out/bin/kubelet" --prefix PATH : "${stdenv.lib.makeBinPath [ utillinux procps-ng ]}"
    chmod +x "$out/libexec/kubernetes/safe_format_and_mount"
    wrapProgram "$out/libexec/kubernetes/safe_format_and_mount" --prefix PATH : "${stdenv.lib.makeBinPath [ e2fsprogs utillinux ]}"
    substituteInPlace "$out"/libexec/kubernetes/cluster/update-storage-objects.sh \
      --replace KUBE_OUTPUT_HOSTBIN KUBE_BIN
  '';

  meta = with stdenv.lib; {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
