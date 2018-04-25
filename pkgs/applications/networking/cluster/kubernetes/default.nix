{ stdenv, lib, fetchFromGitHub, fetchpatch, removeReferencesTo, which, go_1_9, go-bindata, makeWrapper, rsync
, iptables, coreutils
, components ? [
    "cmd/kubeadm"
    "cmd/kubectl"
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "plugin/cmd/kube-scheduler"
    "test/e2e/e2e.test"
  ]
}:

with lib;

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1dmq2g138h7fsswmq4l47b44gsl9anmm3ywqyi7y48f1rkvc11mk";
  };

  # go > 1.10 should be fixed by https://github.com/kubernetes/kubernetes/pull/60373
  buildInputs = [ removeReferencesTo makeWrapper which go_1_9 rsync go-bindata ];

  outputs = ["out" "man" "pause"];

  patches = [
    # patch is from https://github.com/kubernetes/kubernetes/pull/58207
    (fetchpatch {
      url = "https://github.com/kubernetes/kubernetes/commit/a990b04dc8a7d8408a71eee40db93621cf2b6d1b.patch";
      sha256 = "0piqilc5c9frikl74hamkffawwg1mvdwfxqvjnmk6wdma43dbb7w";
    })
    (fetchpatch {
      # https://github.com/kubernetes/kubernetes/pull/60978
      # Fixes critical kube-proxy failure on iptables-restore >= 1.6.2 and
      # non-critical failures on prior versions.
      url = "https://github.com/kubernetes/kubernetes/commit/34ce573e9992ecdbc06dff1b4e3d0e9baa8353dd.patch";
      sha256 = "1sd9qgc28zr6fkk0441f89bw8kq2kadys0qs7bgivy9cmcpw5x5p";
    })
  ];

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
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
