{ stdenv, lib, fetchFromGitHub, removeReferencesTo, which, go, go-bindata, makeWrapper, rsync
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
  pname = "kubernetes";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "0apglhwlyvslni3hz72k83qawj4lm5sb3ljclcb0qk71i311hlbv";
  };

  nativeBuildInputs = [ removeReferencesTo makeWrapper which go rsync go-bindata ];

  outputs = ["out" "man" "pause"];

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

  WHAT=concatStringsSep " " components;

  postBuild = ''
    ./hack/update-generated-docs.sh
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

    cp ${./mk-docker-opts.sh} $out/bin/mk-docker-opts.sh

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
    $out/bin/kubectl completion zsh > $out/share/zsh/site-functions/_kubectl
  '';

  preFixup = ''
    find $out/bin $pause/bin -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = "https://kubernetes.io";
    maintainers = with maintainers; [johanot offline saschagrunert];
    platforms = platforms.unix;
  };
}
