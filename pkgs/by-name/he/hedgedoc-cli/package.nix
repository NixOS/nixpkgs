{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  wget,
  jq,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hedgedoc-cli";
  version = "1.0-unstable-2025-05-01";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "cli";
    rev = "defeac80ca97fedcb19bdcddc516fd8f6e55fe8c";
    hash = "sha256-7E5Ka6SEPRg2O4+bJ6g3gSDMLnPMzg5Lbslgvt6gNEg=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper $src/bin/codimd $out/bin/hedgedoc-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          wget
          curl
        ]
      }

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    hedgedoc-cli help

    runHook postCheck
  '';

  meta = {
    description = "Hedgedoc CLI";
    homepage = "https://github.com/hedgedoc/cli";
    license = lib.licenses.agpl3Only;
    mainProgram = "hedgedoc-cli";
    maintainers = [ ];
  };
})
