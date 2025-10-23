{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  curl,
  recode,
  spidermonkey_140,
}:

stdenv.mkDerivation rec {

  pname = "plowshare";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "mcrapet";
    repo = "plowshare";
    rev = "v${version}";
    hash = "sha256-6fQgJZF5IxRSalB6rUpIVqlwhgbhSG8AuI2qTxswGt0=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,mod,probe,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${
        lib.makeBinPath [
          curl
          recode
          spidermonkey_140
        ]
      }"
    done
  '';

  meta = {
    description = "Command-line download/upload tool for popular file sharing websites";
    homepage = "https://github.com/mcrapet/plowshare";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ aforemny ];
    platforms = lib.platforms.linux;
  };
}
