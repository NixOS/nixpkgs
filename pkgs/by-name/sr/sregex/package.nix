{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "sregex";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openresty";
    repo = "sregex";
    rev = "v${version}";
    hash = "sha256-HZ9O/3BQHHrTVLLlU0o1fLHxyRSesBhreT3IdGHnNsg=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC:=$(CC)"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/openresty/sregex";
    description = "Non-backtracking NFA/DFA-based Perl-compatible regex engine matching on large data streams";
    mainProgram = "sregex-cli";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://github.com/openresty/sregex";
    description = "Non-backtracking NFA/DFA-based Perl-compatible regex engine matching on large data streams";
    mainProgram = "sregex-cli";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
