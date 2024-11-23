{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "shine";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "toots";
    repo = "shine";
    rev = version;
    sha256 = "06nwylqqji0i1isdprm2m5qsdj4qiywcgnp69c5b55pnw43f07qg";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Fast fixed-point mp3 encoding library";
    mainProgram = "shineenc";
    homepage = "https://github.com/toots/shine";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
