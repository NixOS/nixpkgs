{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "terminal-parrot-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = "${version}";
    sha256 = "1b4vr4s1zpkpf5kc1r2kdlp3hf88qp1f7h05g8kd62zf4sfbj722";
  };

  modSha256 = "0ymqhrkgk94z4f2p3c6v75g2h8qlqzdi7byivqzxzmdczmq9zq2s";

  meta = with stdenv.lib; {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = https://github.com/jmhobbs/terminal-parrot;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.heel ];
  };
}
