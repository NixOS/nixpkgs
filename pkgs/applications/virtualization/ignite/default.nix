{ lib
, cni-plugins
, buildGoModule
, firecracker
, containerd
, runc
, makeWrapper
, fetchFromGitHub
, git
}:

buildGoModule rec{
  pname = "ignite";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "ignite";
    rev = "v${version}";
    sha256 = "sha256-WCgNh+iLtxLslzcHuIwVLZpUEhvBJFe1Y84PaPtbtcY=";
    leaveDotGit = true;
  };

  vendorHash = null;

  doCheck = false;

  postPatch = ''
    # ignite tries to run cni-plugins programs from /opt/cni/bin
    substituteInPlace pkg/constants/dependencies.go \
      --replace "/opt/cni/bin/loopback" ${cni-plugins}/bin/loopback \
      --replace "/opt/cni/bin/bridge" ${cni-plugins}/bin/bridge

    # ignite tries to run cni-plugins programs from /opt/cni/bin
    substituteInPlace pkg/network/cni/cni.go \
      --replace "/opt/cni/bin" ${cni-plugins}/bin

    # fetchgit doesn't fetch tags from git repository so it's necessary to force IGNITE_GIT_VERSION to be ${version}
    # also forcing git state to be clean because if it's dirty ignite will try to fetch the image weaveworks/ignite:dev
    # which is not in docker.io, we want it to fetch the image weaveworks/ignite:v${version}
    substituteInPlace hack/ldflags.sh \
      --replace '$(git describe --tags --abbrev=14 "''${IGNITE_GIT_COMMIT}^{commit}" 2>/dev/null)' "v${version}" \
      --replace 'IGNITE_GIT_TREE_STATE="dirty"' 'IGNITE_GIT_TREE_STATE="clean"'
  '';

  nativeBuildInputs = [
    git
    makeWrapper
  ];

  buildInputs = [
    firecracker
  ];

  preBuild = ''
    patchShebangs ./hack/ldflags.sh
    export buildFlagsArray+=("-ldflags=$(./hack/ldflags.sh)")
  '';

  postInstall = ''
    for prog in hack ignite ignited ignite-spawn; do
        wrapProgram "$out/bin/$prog" --prefix PATH : ${lib.makeBinPath [ cni-plugins firecracker containerd runc ]}
    done
  '';

  meta = with lib; {
    description = "Ignite a Firecracker microVM";
    homepage = "https://github.com/weaveworks/ignite";
    license = licenses.asl20;
    maintainers = with maintainers; [ tfmoraes ];
  };
}
