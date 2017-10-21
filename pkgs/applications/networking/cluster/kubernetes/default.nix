{ stdenv, lib, fetchFromGitHub, removeReferencesTo, which, go, go-bindata, makeWrapper, rsync
, iptables, coreutils
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
    "test/e2e/e2e.test"
  ]
}:

with lib;

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "0lxagvv8mysw6n0vp5vsccl87b628dgsjrf298dx2dqx7wn7zjgi";
  };

  buildInputs = [ removeReferencesTo makeWrapper which go rsync go-bindata ];

  outputs = ["out" "man" "pause"];

  postPatch = ''
    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    substituteInPlace "hack/generate-docs.sh" --replace "make" "make SHELL=${stdenv.shell}"
    # hack/update-munge-docs.sh only performs some tests on the documentation.
    # They broke building k8s; disabled for now.
    echo "true" > "hack/update-munge-docs.sh"

    patchShebangs ./hack
  '';

  WHAT="--use_go_build ${concatStringsSep " " components}";

  postBuild = ''
    ./hack/generate-docs.sh
    (cd build/pause && cc pause.c -o pause)
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/bash-completion/completions" "$man/share/man" "$pause/bin"

    cp _output/local/go/bin/* "$out/bin/"
    cp build/pause/pause "$pause/bin/pause"
    cp -R docs/man/man1 "$man/share/man"

    cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons
    patchShebangs $out/bin/kube-addons
    wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
  '';

  preFixup = ''
    find $out/bin $pause/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
