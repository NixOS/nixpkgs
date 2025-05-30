{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  recode,
  spidermonkey_115,
}:

stdenv.mkDerivation rec {

  pname = "plowshare";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "mcrapet";
    repo = "plowshare";
    rev = "v${version}";
    sha256 = "1p8s60dlzaldp006yj710s371aan915asyjhd99188vrj4jj1x79";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    make PREFIX="$out" install

    for fn in plow{del,down,list,mod,probe,up}; do
      wrapProgram "$out/bin/$fn" --prefix PATH : "${
        lib.makeBinPath [
          curl
          recode
          spidermonkey_115
        ]
      }"
    done
  '';

  meta = {
    description = ''
      A command-line download/upload tool for popular file sharing websites
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ aforemny ];
    platforms = lib.platforms.linux;
  };
}
