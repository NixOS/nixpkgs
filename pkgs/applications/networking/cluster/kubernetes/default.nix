{ stdenv, lib, fetchFromGitHub, fetchpatch, removeReferencesTo, which, go_1_9, go-bindata, makeWrapper, rsync
, iptables, coreutils
, components ? [
    "cmd/kubeadm"
    "cmd/kubectl"
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "cmd/kube-scheduler"
    "test/e2e/e2e.test"
  ]
}:

with lib;

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1la9cdf5a67kg72xn4bn5mib1caiv5vxsjmnxqsmx0m7vhbv5i4n";
  };

  # Build using golang v1.9 in accordance with https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.10.md#external-dependencies
  buildInputs = [ removeReferencesTo makeWrapper which go_1_9 rsync go-bindata ];

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
    mkdir -p "$out/bin" "$out/share/bash-completion/completions" "$out/share/zsh/site-functions" "$man/share/man" "$pause/bin"

    cp _output/local/go/bin/* "$out/bin/"
    cp build/pause/pause "$pause/bin/pause"
    cp -R docs/man/man1 "$man/share/man"

    cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons
    patchShebangs $out/bin/kube-addons
    wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
    $out/bin/kubectl completion zsh > $out/share/zsh/site-functions/_kubectl
  '';

  preFixup = ''
    find $out/bin $pause/bin -type f -exec remove-references-to -t ${go_1_9} '{}' +
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = https://kubernetes.io;
    maintainers = with maintainers; [johanot offline];
    platforms = platforms.unix;
  };
}
