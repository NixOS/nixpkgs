{ lib, stdenv, fetchFromGitHub, makeWrapper, coreutils, findutils, getopt, gnugrep, gnused, sops, vault }:

stdenv.mkDerivation rec {
  pname = "helm-secrets";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "jkroepke";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RACETma0AaqaAfe0HWC541/i+knr+emMUauFWnkEuMI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ getopt sops ];

  # NOTE: helm-secrets is comprised of shell scripts.
  dontBuild = true;

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/${pname} $out/${pname}/scripts
    install -m644 -Dt $out/${pname} plugin.yaml
    cp -r scripts/* $out/${pname}/scripts
    wrapProgram $out/${pname}/scripts/run.sh \
        --prefix PATH : ${lib.makeBinPath [ coreutils findutils getopt gnugrep gnused sops vault ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Helm plugin that helps manage secrets";
    inherit (src.meta) homepage;
    license = licenses.apsl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
