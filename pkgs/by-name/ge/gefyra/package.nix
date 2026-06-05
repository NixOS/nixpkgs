{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  docker,
  kubectl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gefyra";
  version = "2.4.7";

  src = fetchzip {
    url = "https://github.com/gefyrahq/gefyra/releases/download/${finalAttrs.version}/gefyra-${finalAttrs.version}-linux-amd64.zip";
    hash = "sha256-6RJgEl/uteoitNumw5upkozPCrNPW1kC1STLRyycHiY=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 gefyra "$out/bin/gefyra"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/gefyra \
      --prefix PATH : ${
        lib.makeBinPath [
          docker
          kubectl
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to connect local containers to kubernetes clusters";
    homepage = "https://gefyra.dev";
    downloadPage = "https://github.com/gefyrahq/gefyra";
    mainProgram = "gefyra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tobifroe ];
    platforms = lib.platforms.linux;
  };
})
