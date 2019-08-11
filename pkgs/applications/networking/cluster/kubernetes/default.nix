{ stdenv, lib, fetchFromGitHub, removeReferencesTo, makeWrapper
, which, go, go-bindata, rsync
, components ? [
  "cmd/kubeadm"
  "cmd/kubectl"
  "cmd/kubelet"
  "cmd/kube-apiserver"
  "cmd/kube-controller-manager"
  "cmd/kube-proxy"
  "cmd/kube-scheduler"
  "test/e2e/e2e.test"
]}:

with lib;

let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);

  generic = { version, sha256 }: stdenv.mkDerivation {
    pname = "kubernetes";
    inherit version;

    src = fetchFromGitHub {
      owner = "kubernetes";
      repo = "kubernetes";
      rev = "v${version}";
      inherit sha256;
    };

    buildInputs = [ removeReferencesTo makeWrapper which go rsync go-bindata ];

    outputs = ["out" "man" "pause"];

    binaries = [
      "kubectl"
      "kubeadm"
      "kube-apiserver"
      "kube-controller-manager"
      "kube-scheduler"
      "kubelet"
      "kubemark"
      "hyperkube"
      "kube-proxy"
      "cloud-controller-manager"
      "e2e.test"
    ];

    WHAT = concatStringsSep " " components;

    preBuild = "export HOME=$PWD";

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

    postBuild = ''
      ./hack/update-generated-docs.sh
      (cd build/pause && cc pause.c -o pause)
    '';

    installPhase = ''
      mkdir -p "$out/bin" "$out/share/bash-completion/completions" "$out/share/zsh/site-functions" "$man/share/man" "$pause/bin"

      for binary in $binaries; do
        if [ -f "_output/local/go/bin/$binary" ]; then
          cp "_output/local/go/bin/$binary" "$out/bin/"
        fi
      done

      cp build/pause/pause "$pause/bin/pause"
      cp -R docs/man/man1 "$man/share/man"

      ${optionalString ((builtins.compareVersions version "1.15") < 0) ''
      cp cluster/addons/addon-manager/namespace.yaml $out/share
      cp cluster/addons/addon-manager/kube-addons.sh $out/bin/kube-addons
      cp ${./mk-docker-opts.sh} $out/bin/mk-docker-opts.sh
      patchShebangs $out/bin/kube-addons
      substituteInPlace $out/bin/kube-addons \
        --replace /opt/namespace.yaml $out/share/namespace.yaml
      '' + optionalString (elem "cmd/kubectl" components) ''
      wrapProgram $out/bin/kube-addons --set "KUBECTL_BIN" "$out/bin/kubectl"
      ''}

      ${optionalString (elem "cmd/kubectl" components) ''
      $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
      $out/bin/kubectl completion zsh > $out/share/zsh/site-functions/_kubectl
      ''}
    '';

    preFixup = ''
      find $out/bin $pause/bin -type f -exec remove-references-to -t ${go} '{}' +
    '';

    meta = {
      description = "Production-Grade Container Scheduling and Management";
      license = licenses.asl20;
      homepage = https://kubernetes.io;
      maintainers = with maintainers; [johanot offline];
      platforms = platforms.unix;
    };
  };

  minorVersion = version: concatStringsSep "_" (take 2 (builtins.splitVersion version));

  mkName = version: "kubernetes_${minorVersion version}";

  mkVersion = version: nameValuePair (mkName version.version) (generic version);

in lib.listToAttrs (map mkVersion versions)
