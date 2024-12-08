{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  codeowners,
  jq,
  curl,
  github-cli,
  gitMinimal,
}:
stdenvNoCC.mkDerivation {
  name = "request-reviews";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./get-reviewers.sh
      ./request-reviews.sh
      ./verify-base-branch.sh
      ./dev-branches.txt
    ];
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    mv dev-branches.txt $out/bin
    for bin in *.sh; do
      mv "$bin" "$out/bin"
      wrapProgram "$out/bin/$bin" \
        --set PATH ${
          lib.makeBinPath [
            coreutils
            codeowners
            jq
            curl
            github-cli
            gitMinimal
          ]
        }
    done
  '';
}
