{
  bats,
  coreutils,
  fetchFromGitHub,
  getopt,
  lib,
  makeWrapper,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "locate-dominating-file";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "roman";
    repo = "locate-dominating-file";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gwh6fAw7BV7VFIkQN02QIhK47uxpYheMk64UeLyp2IY=";
  };

  postPatch = ''
    for file in $(find src tests -type f); do
      patchShebangs "$file"
    done
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    (bats.withLibraries (p: [
      p.bats-support
      p.bats-assert
    ]))
    coreutils
    getopt
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bats -t tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 src/locate-dominating-file.sh $out/bin/locate-dominating-file

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/locate-dominating-file \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          getopt
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/roman/locate-dominating-file";
    description = "Program that looks up in a directory hierarchy for a given filename";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.roman ];
    platforms = lib.platforms.all;
    mainProgram = "locate-dominating-file";
  };
})
