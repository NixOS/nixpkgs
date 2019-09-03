{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terminal-parrot";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = "${version}";
    sha256 = "1b4vr4s1zpkpf5kc1r2kdlp3hf88qp1f7h05g8kd62zf4sfbj722";
  };

  modSha256 = "01i8fim9z2l8rpdgfaih9ldvbap7gcx5767a15miv8q7sxpr90cp";

  meta = with stdenv.lib; {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = https://github.com/jmhobbs/terminal-parrot;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.heel ];
  };
}
