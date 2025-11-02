{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  jq,
  github-cli,
}:
stdenvNoCC.mkDerivation {
  name = "request-reviews";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./request-reviewers.sh
    ];
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    for bin in *.sh; do
      mv "$bin" "$out/bin"
      wrapProgram "$out/bin/$bin" \
        --set PATH ${
          lib.makeBinPath [
            coreutils
            jq
            github-cli
          ]
        }
    done
  '';
}
