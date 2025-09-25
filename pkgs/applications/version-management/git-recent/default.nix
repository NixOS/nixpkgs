{
  lib,
  stdenv,
  git,
  less,
  fetchFromGitHub,
  makeWrapper,
  # util-linuxMinimal is included because we need the column command
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-recent";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-recent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b6AWLEXCOza+lIHlvyYs3M6yHGr2StYXzl7OsA9gv/k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin
    cp git-recent $out/bin
    wrapProgram $out/bin/git-recent \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          less
          util-linux
        ]
      }"
  '';

  meta = {
    homepage = "https://github.com/paulirish/git-recent";
    description = "See your latest local git branches, formatted real fancy";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jlesquembre ];
    mainProgram = "git-recent";
  };
})
