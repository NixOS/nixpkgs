{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  babashka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neil";
  version = "0.3.69";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = "neil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRuWRZRh93lQjfi3C+gliixZYAZ/JZRMZJbcPv29YFI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -D neil $out/bin/neil
    wrapProgram $out/bin/neil \
      --prefix PATH : "${lib.makeBinPath [ babashka ]}"
  '';

  meta = {
    homepage = "https://github.com/babashka/neil";
    description = "CLI to add common aliases and features to deps.edn-based projects";
    mainProgram = "neil";
    license = lib.licenses.mit;
    platforms = babashka.meta.platforms;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
