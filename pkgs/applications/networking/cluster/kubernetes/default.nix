{ stdenv, fetchFromGitHub, removeReferencesTo
, coreutils, go, go-bindata, iptables, kube-dns, rsync, which
, components ? [
    "cmd/kubeadm"
    "cmd/kubectl"
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "plugin/cmd/kube-scheduler"
    "federation/cmd/federation-apiserver"
    "federation/cmd/federation-controller-manager"
  ]
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "0yj0c7k5v6ri1pnh7cmfqf0ckf8psh9929im1liy0lhlga7yipx4";
  };

  buildInputs = [ removeReferencesTo which go rsync go-bindata ];

  outputs = [ "out" "man" "pause" ];
  passthru.dns = kube-dns;

  postPatch = ''
    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    substituteInPlace "hack/generate-docs.sh" --replace "make" "make SHELL=${stdenv.shell}"

    patchShebangs ./hack
  '';

  WHAT = "--use_go_build ${concatStringsSep " " components}";

  postBuild = ''
    ./hack/generate-docs.sh
    (cd build/pause && cc pause.c -o pause)
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/bash-completion/completions" "$man/share/man" "$pause/bin"

    cp _output/local/go/bin/* "$out/bin/"
    cp build/pause/pause "$pause/bin/pause"
    cp -R docs/man/man1 "$man/share/man"

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
  '';

  preFixup = ''
    find $out/bin $pause/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [ offline lnl7 ];
    platforms = platforms.unix;
  };
}
