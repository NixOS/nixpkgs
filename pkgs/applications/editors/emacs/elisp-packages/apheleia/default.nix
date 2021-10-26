{ lib
, stdenv
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "apheleia";
  version = "1.1.2+unstable=2021-10-03";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = pname;
    rev = "8b9d576f2fda10d0c9051fc03c1eb1d9791e32fd";
    hash = "sha256-QwGlCdHBll16mbfQxGw1EORZFUxYCZSt8ThYTTGjRpo=";
  };

  buildInputs = [
    emacs
  ];

  meta = with lib; {
    homepage = "https://github.com/raxod502/apheleia";
    description = "Asynchronous buffer reformat";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres leungbk ];
    platforms = emacs.meta.platforms;
  };
}
