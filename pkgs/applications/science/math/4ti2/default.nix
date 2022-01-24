{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, glpk
, gmp
}:

stdenv.mkDerivation rec{
  pname = "4ti2";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release_${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-cywneIM0sHt1iQsNfjyQDoDfdRjxpz4l3rfysi9YN20=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    glpk
    gmp
  ];

  installFlags = [ "install-exec" ];

  meta = with lib;{
    homepage = "https://4ti2.github.io/";
    description = "A software package for algebraic, geometric and combinatorial problems on linear spaces";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
