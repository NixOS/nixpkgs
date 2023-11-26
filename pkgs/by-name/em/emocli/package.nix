{ lib, nimPackages, fetchFromGitLab, unicode-emoji }:

nimPackages.buildNimPackage rec {
  pname = "emocli";
  version = "1.0.0";
  src = fetchFromGitLab {
    owner = "AsbjornOlling";
    repo = "emocli";
    rev = "v${version}";
    hash = "sha256-yJu+8P446gzRFOi9/+TcN8AKL0jKHUxhOvi/HXNWL1A=";
  };
  nimFlags = [
    "-d:release"
    "--maxLoopIterationsVM:1000000000"
  ];
  doCheck = true;
  env.EMOCLI_DATAFILE = "${unicode-emoji}/share/unicode/emoji/emoji-test.txt";
  meta = with lib; {
    homepage = "https://gitlab.com/AsbjornOlling/emocli";
    description = "The emoji picker for your command line";
    license = licenses.eupl12;
    maintainers = with maintainers; [ asbjornolling ];
    mainProgram = "emocli";
  };
}
