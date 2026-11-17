{
  stdenv,
  lib,
  fetchFromSourcehut,
  hareHook,
  hareThirdParty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-lsp";
  version = "0.2.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "hare-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uXH/T6JOA9cBFcLhCwY0mf4AA/VSrtVEiKfpAiVq2Ik=";
  };

  nativeBuildInputs = [
    hareHook
    hareThirdParty.hare-json
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Language server implementation for Hare";
    homepage = "https://git.sr.ht/~whynothugo/hare-lsp";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "hare-lsp";
  };
})
