{
  lib,
  fetchFromGitHub,
  python3,
  stdenv,
}:
let
  pythonEnv = python3.withPackages (ps: [
    ps.pyyaml
    ps.diagrams
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kube-diagrams";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "philippemerle";
    repo = "KubeDiagrams";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+LEzrJVb4fn3mURRiQQ8MpQKiLeRjaOU6qy6F3rNTIs=";
  };

  postPatch = ''
    substituteInPlace bin/kube-diagrams \
      --replace-fail '/usr/bin/env python3' '${pythonEnv}/bin/python'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bin/* $out/bin/
    chmod +x $out/bin/*-diagrams

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
