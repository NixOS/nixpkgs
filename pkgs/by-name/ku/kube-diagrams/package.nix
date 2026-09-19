{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
  stdenv,
}:
let
  pythonEnv = python3.withPackages (ps: [
    ps.pyyaml
    ps.diagrams
    ps.pygraphviz
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kube-diagrams";

  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "philippemerle";
    repo = "KubeDiagrams";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C/hY3+fWWYvufox1T5smzhCZAHwIc6B2cqKNxZgh+0Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace bin/kube-diagrams \
      --replace-fail '/usr/bin/env python3' '${pythonEnv}/bin/python'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kube-diagrams $out/bin
    cp -r bin/* $out/share/kube-diagrams/
    chmod +x $out/share/kube-diagrams/*-diagrams

    # kube-diagrams locates its yaml config and icons next to itself via
    # os.path.dirname(__file__), which does not resolve symlinks
    makeWrapper $out/share/kube-diagrams/kube-diagrams $out/bin/kube-diagrams
    ln -s $out/share/kube-diagrams/helm-diagrams $out/bin/helm-diagrams
    ln -s $out/share/kube-diagrams/kubectl-diagrams $out/bin/kubectl-diagrams

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/philippemerle/KubeDiagrams/releases/tag/v${finalAttrs.version}";
    description = "Generate Kubernetes architecture diagrams from Kubernetes manifest files, kustomization files, Helm charts, helmfiles, and actual cluster state";
    homepage = "https://kubediagrams.lille.inria.fr";
    license = lib.licenses.asl20;
    mainProgram = "kube-diagrams";
    maintainers = with lib.maintainers; [ allsimon ];
    platforms = lib.platforms.all;
  };
})
