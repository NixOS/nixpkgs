{ stdenv, lib, fetchFromGitHub, which, go, go-bindata, makeWrapper, rsync
, iptables, coreutils
, components ? [
    "cmd/kubectl"
    "cmd/kubelet"
    "cmd/kube-apiserver"
    "cmd/kube-controller-manager"
    "cmd/kube-proxy"
    "plugin/cmd/kube-scheduler"
    "cmd/kube-dns"
    "federation/cmd/federation-apiserver"
    "federation/cmd/federation-controller-manager"
  ]
}:

with lib;

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1n5ppzr9hnn7ljfdgx40rnkn6n6a9ya0qyrhjhpnbfwz5mdp8ws3";
  };

  buildInputs = [ makeWrapper which go rsync go-bindata ];

  outputs = ["out" "man" "pause"];

  postPatch = ''
    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    substituteInPlace "hack/generate-docs.sh" --replace "make" "make SHELL=${stdenv.shell}"
    substituteInPlace "hack/update-munge-docs.sh" --replace "make" "make SHELL=${stdenv.shell}"
    substituteInPlace "hack/update-munge-docs.sh" --replace "kube::util::git_upstream_remote_name" "echo origin"

    patchShebangs ./hack
  '';

  WHAT="--use_go_build ${concatStringsSep " " components}";

  postBuild = ''
    ./hack/generate-docs.sh
    (cd build/pause && gcc pause.c -o pause)
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/bash-completion/completions" "$man/share/man" "$pause/bin"

    cp _output/local/go/bin/* "$out/bin/"
    cp build/pause/pause "$pause/bin/pause"
    cp -R docs/man/man1 "$man/share/man"

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
  '';

  preFixup = ''
    # Remove references to go compiler
    while read file; do
      cat $file | sed "s,${go},$(echo "${go}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" > $file.tmp
      mv $file.tmp $file
      chmod +x $file
    done < <(find $out/bin $pause/bin -type f 2>/dev/null)
  '';

  meta = {
    description = "Production-Grade Container Scheduling and Management";
    license = licenses.asl20;
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
