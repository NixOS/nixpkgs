{ stdenv, lib, buildGoPackage, fetchFromGitHub, go }:

with lib;

stdenv.mkDerivation rec {
  name = "kube-dns-${version}";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "dns";
    rev = "${version}";
    sha256 = "13l42wm2rcz1ina8hhhagbnck6f1gdbwj33dmnrr52pwi1xh52f7";
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH="$(pwd)/.gopath"
    mkdir $GOPATH
    ln -s $(pwd)/vendor $GOPATH/src
    mkdir $GOPATH/src/k8s.io/dns
    ln -s $(pwd)/cmd $GOPATH/src/k8s.io/dns/cmd
    ln -s $(pwd)/pkg $GOPATH/src/k8s.io/dns/pkg

    # build only kube-dns, we do not need anything else
    go build -o kube-dns ./cmd/kube-dns
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kube-dns $out/bin
  '';

  meta = {
    description = "Kubernetes DNS service";
    license = licenses.asl20;
    homepage = https://github.com/kubernetes/dns;
    maintainers = with maintainers; [ matejc ];
    platforms = platforms.unix;
  };
}
