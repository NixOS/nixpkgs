{ stdenv
, lib
, fetchFromGitHub
, removeReferencesTo
, which
, go
, makeWrapper
, rsync
, installShellFiles

, components ? [
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "cmd/kube-scheduler"
    "test/e2e/e2e.test"
  ]
}:

stdenv.mkDerivation rec {
  pname = "kubernetes";
  version = "1.19.5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "15bv620fj4x731f2z2a9dcdss18rk379kc40g49bpqsdn42jjx2z";
  };

  nativeBuildInputs = [ removeReferencesTo makeWrapper which go rsync installShellFiles ];

  outputs = [ "out" "man" "pause" ];

  postPatch = ''
    # go env breaks the sandbox
    substituteInPlace "hack/lib/golang.sh" \
      --replace 'echo "$(go env GOHOSTOS)/$(go env GOHOSTARCH)"' 'echo "${go.GOOS}/${go.GOARCH}"'

    substituteInPlace "hack/update-generated-docs.sh" --replace "make" "make SHELL=${stdenv.shell}"
    # hack/update-munge-docs.sh only performs some tests on the documentation.
    # They broke building k8s; disabled for now.
    echo "true" > "hack/update-munge-docs.sh"

    patchShebangs ./hack
  '';

  WHAT = lib.concatStringsSep " " ([
    "cmd/kubeadm"
    "cmd/kubectl"
  ] ++ components);

  postBuild = ''
    ./hack/update-generated-docs.sh
    (cd build/pause && cc pause.c -o pause)
  '';

  installPhase = ''
    for p in $WHAT; do
      install -D _output/local/go/bin/''${p##*/} -t $out/bin
    done

    install -D build/pause/pause -t $pause/bin
    installManPage docs/man/man1/*.[1-9]

    cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons
    patchShebangs $out/bin/kube-addons
    wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"

    cp ${./mk-docker-opts.sh} $out/bin/mk-docker-opts.sh

    for tool in kubeadm kubectl; do
      installShellCompletion --cmd $tool \
        --bash <($out/bin/$tool completion bash) \
        --zsh <($out/bin/$tool completion zsh)
    done
  '';

  preFixup = ''
    find $out/bin $pause/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = with lib; {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = "https://kubernetes.io";
    maintainers = with maintainers; [ johanot offline saschagrunert ];
    platforms = platforms.unix;
  };
}
