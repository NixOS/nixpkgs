{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "maildir-rank-addr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ferdinandyb";
    repo = "maildir-rank-addr";
    rev = "v${version}";
    hash = "sha256-LABqd9FojbQUG3c0XBH5ZKsJNPTMEt3Yzn6gpYEWddc=";
  };

  vendorHash = "sha256-Mqx938j8LwM+bDnrK3V46FFy86JbVoh9Zxr/CA/egk8=";

  meta = with lib; {
    description = "Creates a ranked list of email addresses from maildir folders";
    homepage = "https://github.com/ferdinandyb/maildir-rank-addr/";
    maintainers = with maintainers; [ ryangibb ];
    mainProgram = "maildir-rank-addr";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
