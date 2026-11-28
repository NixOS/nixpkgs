{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcp";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "kcp";
    tag = finalAttrs.version;
    hash = "sha256-K0kPQ2YjwwHkbGelo3KNcl+PpDnbk/FxDxYMu+VDARM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fast and Reliable ARQ Protocol";
    homepage = "https://github.com/skywind3000/kcp";
    changelog = "https://github.com/skywind3000/kcp/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samirbgno ];
    platforms = lib.platforms.all;
  };
})
