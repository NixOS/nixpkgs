{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  libsodium,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxeddsa";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "libxeddsa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kdy+S51nQstRFGw5mIW3TW+WBNynHLpmFC1t6Mc02K4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libsodium ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Toolkit around Curve25519 and Ed25519 key pairs";
    homepage = "https://github.com/Syndace/libxeddsa";
    changelog = "https://github.com/Syndace/libxeddsa/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
