{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables, rsync, utillinux, coreutils, e2fsprogs, procps-ng }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "12wqw9agiz07wlw1sd0n41fn6xf74zn5sv37hslfa77w2d4ri5yb";
  };

  buildInputs = [ makeWrapper which go iptables rsync ];

  buildPhase = ''
    GOPATH=$(pwd):$(pwd)/Godeps/_workspace
    mkdir -p $(pwd)/Godeps/_workspace/src/github.com/GoogleCloudPlatform
    ln -s $(pwd) $(pwd)/Godeps/_workspace/src/github.com/GoogleCloudPlatform/kubernetes

    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    patchShebangs ./hack
    hack/build-go.sh --use_go_build

    (cd cluster/addons/dns/kube2sky && go build ./kube2sky.go)
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out"/libexec/kubernetes/cluster
    cp _output/local/go/bin/{kube*,hyperkube} "$out/bin/"
    cp cluster/addons/dns/kube2sky/kube2sky "$out/bin/"
    cp cluster/saltbase/salt/helpers/safe_format_and_mount "$out/libexec/kubernetes"
    cp -R hack "$out/libexec/kubernetes"
    cp cluster/update-storage-objects.sh "$out/libexec/kubernetes/cluster"
    makeWrapper "$out"/libexec/kubernetes/cluster/update-storage-objects.sh "$out"/bin/kube-update-storage-objects \
      --prefix KUBE_BIN : "$out/bin"
  '';

  preFixup = ''
    wrapProgram "$out/bin/kube-proxy" --prefix PATH : "${iptables}/bin"
    wrapProgram "$out/bin/kubelet" --prefix PATH : "${utillinux}/bin:${procps-ng}/bin"
    chmod +x "$out/libexec/kubernetes/safe_format_and_mount"
    wrapProgram "$out/libexec/kubernetes/safe_format_and_mount" --prefix PATH : "${e2fsprogs}/bin:${utillinux}/bin"
    substituteInPlace "$out"/libexec/kubernetes/cluster/update-storage-objects.sh \
      --replace KUBE_OUTPUT_HOSTBIN KUBE_BIN
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of container cluster management";
    license = licenses.asl20;
    homepage = https://github.com/GoogleCloudPlatform;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
