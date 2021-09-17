{ lib
, stdenv
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "apheleia";
  version = "0.0.0+unstable=2021-08-08";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = pname;
    rev = "8e022c67fea4248f831c678b31c19646cbcbbf6f";
    hash = "sha256-Put/BBQ7V423C18UIVfaM17T+TDWtAxRZi7WI8doPJw=";
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
