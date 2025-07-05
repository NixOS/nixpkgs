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
    rev = "${finalAttrs.version}";
    hash = "sha256-Kr3VQ56V+Neo4CrKX5AasuftXNNJCx4NnsPz1UBBCog=";
  };
  buildInputs = [
    bison
    flex
    lcrq
    librecast
    libsodium
  ];
  installFlags = [ "PREFIX=$(out)" ];
  doCheck = true;

  meta = {
    changelog = "https://codeberg.org/librecast/lcagent/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "lcagent is the Librecast multicast agent.";
    mainProgram = "lcagent";
    homepage = "https://librecast.net/lcagent.html";
    license = [
      lib.licenses.gpl2
      lib.licenses.gpl3
    ];
    maintainers = with lib.maintainers; [ jleightcap ];
    platforms = lib.platforms.gnu;
  };
})
