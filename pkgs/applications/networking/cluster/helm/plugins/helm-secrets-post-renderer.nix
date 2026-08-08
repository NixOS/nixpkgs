{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  findutils,
  getopt,
  gnugrep,
  gnused,
  sops,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "helm-secrets-post-renderer";
  version = "4.7.7";

  src = fetchFromGitHub {
    owner = "jkroepke";
    repo = "helm-secrets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TfVKrSkr5kAwGZ6HR6m6sX3VN9LEPQYvjshYpD+R6XI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    getopt
    sops
  ];

  # NOTE: helm-secrets is comprised of shell scripts.
  dontBuild = true;

  # NOTE: Fix version string in the Helm 4 post-renderer plugin manifest.
  postPatch = ''
    sed -i 's/^version:.*/version: "${finalAttrs.version}"/' plugins/helm-secrets-post-renderer/plugin.yaml
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/${finalAttrs.pname} $out/${finalAttrs.pname}/scripts
    install -m644 -Dt $out/${finalAttrs.pname} plugins/helm-secrets-post-renderer/plugin.yaml
    cp -rL scripts/* $out/${finalAttrs.pname}/scripts
    wrapProgram $out/${finalAttrs.pname}/scripts/run.sh \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            getopt
            gnugrep
            gnused
            sops
          ]
        }

    runHook postInstall
  '';

  meta = {
    description = "Helm secrets post-renderer plugin for evaluate-templates support";
    homepage = "https://github.com/jkroepke/helm-secrets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yurrriq ];
    platforms = lib.platforms.unix;
  };
})
