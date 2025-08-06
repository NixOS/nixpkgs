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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "libxeddsa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4xBZ3Ul2Mm5fz/vfulFQmWC6+CQB/egiw7NsC/GrUyw=";
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
