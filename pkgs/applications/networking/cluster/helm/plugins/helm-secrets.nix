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

stdenv.mkDerivation rec {
  pname = "helm-secrets";
  version = "4.6.10";

  src = fetchFromGitHub {
    owner = "jkroepke";
    repo = "helm-secrets";
    rev = "v${version}";
    hash = "sha256-hno6+kik+U9XA7Mr9OnuuVidfc/xoqWRjMbBMI6M3QA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    getopt
    sops
  ];

  # NOTE: helm-secrets is comprised of shell scripts.
  dontBuild = true;

  # NOTE: Fix version string
  postPatch = ''
    sed -i 's/^version:.*/version: "${version}"/' plugin.yaml
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/helm-secrets $out/helm-secrets/scripts
    install -m644 -Dt $out/helm-secrets plugin.yaml
    cp -r scripts/* $out/helm-secrets/scripts
    wrapProgram $out/helm-secrets/scripts/run.sh \
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

  meta = with lib; {
    description = "Helm plugin that helps manage secrets";
    homepage = "https://github.com/jkroepke/helm-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.unix;
  };
}
