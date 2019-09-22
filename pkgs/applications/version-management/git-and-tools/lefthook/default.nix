{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "0.6.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Arkweid";
    repo = "lefthook";
    sha256 = "01zvlw2yyxjg92d1qag1b42kc2kd68h4fmrv9y6ar7z0rw3p9a5d";
  };

  modSha256 = "0mjhw778x40c2plmjlkiry4rwvr9xkz65b88a61j86liv2plbmq2";

  meta = with stdenv.lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
