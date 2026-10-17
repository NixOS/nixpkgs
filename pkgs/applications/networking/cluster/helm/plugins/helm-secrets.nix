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
  pname = "helm-secrets";
  version = "4.7.9";

  src = fetchFromGitHub {
    owner = "jkroepke";
    repo = "helm-secrets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MXeuc54StPKWhflbdEoTuDh1hOx0CZeLXtpGa9Lzm/c=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    getopt
    sops
  ];

  # NOTE: helm-secrets is comprised of shell scripts.
  dontBuild = true;

  # NOTE: Fix version string in the Helm 4 CLI plugin manifest.
  postPatch = ''
    sed -i 's/^version:.*/version: "${finalAttrs.version}"/' plugins/helm-secrets-cli/plugin.yaml
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/${finalAttrs.pname} $out/${finalAttrs.pname}/scripts
    install -m644 -Dt $out/${finalAttrs.pname} plugins/helm-secrets-cli/plugin.yaml
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
    description = "Helm plugin that helps manage secrets";
    homepage = "https://github.com/jkroepke/helm-secrets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yurrriq ];
    platforms = lib.platforms.unix;
  };
})
