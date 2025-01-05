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
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "jkroepke";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s76XIB7s92zSzG8GGsJJuTG3cwbGHL7oc1x30k/WoOU=";
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

    install -dm755 $out/${pname} $out/${pname}/scripts
    install -m644 -Dt $out/${pname} plugin.yaml
    cp -r scripts/* $out/${pname}/scripts
    wrapProgram $out/${pname}/scripts/run.sh \
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
