{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables, rsync, utillinux, coreutils }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1adbd5n2fs1278f6kz6pd23813w2k4pgcxjl21idflh8jafxsyj7";
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
    mkdir -p "$out/bin"
    cp _output/local/go/bin/* "$out/bin/"
    cp cluster/addons/dns/kube2sky/kube2sky "$out/bin/"
  '';

  preFixup = ''
    wrapProgram "$out/bin/kube-proxy" --prefix PATH : "${iptables}/bin"
    wrapProgram "$out/bin/kubelet" --prefix PATH : "${utillinux}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of container cluster management";
    license = licenses.asl20;
    homepage = https://github.com/GoogleCloudPlatform;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
