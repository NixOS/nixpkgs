{
  lib,
  buildNimPackage,
  fetchFromGitLab,
  unicode-emoji,
}:

buildNimPackage (finalAttrs: {
  pname = "emocli";
  version = "1.0.0";
  src = fetchFromGitLab {
    owner = "AsbjornOlling";
    repo = "emocli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yJu+8P446gzRFOi9/+TcN8AKL0jKHUxhOvi/HXNWL1A=";
  };
  nimFlags = [
    "--maxLoopIterationsVM:1000000000"
  ];
  env.EMOCLI_DATAFILE = "${unicode-emoji}/share/unicode/emoji/emoji-test.txt";
  meta = {
    homepage = "https://gitlab.com/AsbjornOlling/emocli";
    description = "The emoji picker for your command line";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ asbjornolling ];
    mainProgram = "emocli";
  };
})
