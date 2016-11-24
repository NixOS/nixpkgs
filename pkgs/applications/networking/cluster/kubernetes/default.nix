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
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "13lzprvifppnz2r189di7ff2jhvd071b6hxyny12p2hw1b3knnvb";
  };

  buildInputs = [ makeWrapper which go rsync go-bindata ];

  outputs = ["out" "man""pause"];

  postPatch = ''
    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    patchShebangs ./hack
  '';

  WHAT="--use_go_build ${concatStringsSep " " components}";

  postBuild = "(cd build/pause && gcc pause.c -o pause)";

  installPhase = ''
    mkdir -p "$out/bin" "$man/share/man" "$pause/bin"

    cp _output/local/go/bin/* "$out/bin/"
    cp build/pause/pause "$pause/bin/pause"
    cp -R docs/man/man1 "$man/share/man"
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
