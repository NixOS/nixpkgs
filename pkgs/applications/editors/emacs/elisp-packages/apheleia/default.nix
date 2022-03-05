{ lib
, stdenv
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "apheleia";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yd9yhQOs0+RB8RKaXnV/kClDm8cO97RkC8yw5b8IKRo=";
  };

  buildInputs = [
    emacs
  ];

  meta = with lib; {
    homepage = "https://github.com/raxod502/apheleia";
    description = "Asynchronous buffer reformat";
    longDescription = ''
      Run code formatter on buffer contents without moving point, using RCS
      patches and dynamic programming.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres leungbk ];
    inherit (emacs.meta) platforms;
  };
}
