{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terminal-parrot";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = version;
    sha256 = "1b4vr4s1zpkpf5kc1r2kdlp3hf88qp1f7h05g8kd62zf4sfbj722";
  };

  vendorSha256 = "1qalnhhq3fmyzj0hkzc5gk9wbypr558mz3ik5msw7fid68k2i48c";

  doCheck = false;

  meta = with lib; {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = "https://github.com/jmhobbs/terminal-parrot";
    license = licenses.mit;
    maintainers = [ maintainers.heel ];
  };
}
