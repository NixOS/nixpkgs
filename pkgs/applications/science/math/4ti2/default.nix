{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, glpk
, gmp
}:

stdenv.mkDerivation rec{
  pname = "4ti2";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release_${builtins.replaceStrings ["."] ["_"] version}";
    hash = "sha256-Rz8O1Tf81kzpTGPq7dkZJvv444F1/VqKu7VuRvH59kQ=";
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
    description = "Software package for algebraic, geometric and combinatorial problems on linear spaces";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
