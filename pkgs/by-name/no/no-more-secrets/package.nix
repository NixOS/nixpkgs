{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "no-more-secrets";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bartobri";
    repo = "no-more-secrets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QVCEpplsZCSQ+Fq1LBtCuPBvnzgLsmLcSrxR+e4nA5I=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/nms $out/bin/nms
    installManPage nms.6
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/bartobri/no-more-secrets";
    description = "Command line tool that recreates the famous data decryption effect seen in the 1992 movie Sneakers";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.unix;
    mainProgram = "nms";
  };
})
