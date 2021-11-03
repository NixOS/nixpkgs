{ stdenv
, lib
, fetchFromGitHub
, removeReferencesTo
, which
, go
, makeWrapper
, rsync
, installShellFiles
, nixosTests

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
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "sha256-yXis1nq36MO/RnYLxOYBs6xnaTf9lk+VJBzSamrHcEU=";
  };

  nativeBuildInputs = [ removeReferencesTo makeWrapper which go rsync installShellFiles ];

  outputs = [ "out" "man" "pause" ];

  patches = [ ./fixup-addonmanager-lib-path.patch ];

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
    (cd build/pause/linux && cc pause.c -o pause)
  '';

  installPhase = ''
    runHook preInstall
    for p in $WHAT; do
      install -D _output/local/go/bin/''${p##*/} -t $out/bin
    done

    install -D build/pause/linux/pause -t $pause/bin
    installManPage docs/man/man1/*.[1-9]

    # Unfortunately, kube-addons-main.sh only looks for the lib file in either the
    # current working dir or in /opt. We have to patch this for now.
    substitute cluster/addons/addon-manager/kube-addons-main.sh $out/bin/kube-addons \
      --subst-var out

    chmod +x $out/bin/kube-addons
    patchShebangs $out/bin/kube-addons
    wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"

    cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons-lib.sh

    for tool in kubeadm kubectl; do
      installShellCompletion --cmd $tool \
        --bash <($out/bin/$tool completion bash) \
        --zsh <($out/bin/$tool completion zsh)
    done
    runHook postInstall
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

  passthru.tests = nixosTests.kubernetes;
}
