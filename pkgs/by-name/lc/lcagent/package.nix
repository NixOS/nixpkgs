{
  fetchFromGitea,
  lib,
  stdenv,
  flex,
  bison,
  librecast,
  libsodium,
  lcrq,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lcagent";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcagent";
    tag = finalAttrs.version;
    hash = "sha256-Kr3VQ56V+Neo4CrKX5AasuftXNNJCx4NnsPz1UBBCog=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    lcrq
    librecast
    libsodium
  ];
  installFlags = [ "PREFIX=$(out)" ];
  doCheck = true;

  meta = {
    changelog = "https://codeberg.org/librecast/lcagent/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Librecast multicast agent";
    homepage = "https://librecast.net/lcagent.html";
    license = [
      lib.licenses.gpl2Only
      lib.licenses.gpl3Only
    ];
    mainProgram = "lcagent";
    maintainers = with lib.maintainers; [
      jleightcap
      jasonodoom
    ];
    platforms = lib.platforms.gnu;
  };
})
