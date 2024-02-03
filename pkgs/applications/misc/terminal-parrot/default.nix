{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terminal-parrot";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = version;
    hash = "sha256-Qhy5nCbuC9MmegXA48LFCDk4Lm1T5MBmcXfeHzTJm6w=";
  };

  vendorHash = "sha256-DJEoJjItusN1LTOOX1Ep+frF03yF/QmB/L66gSG0VOE=";

  doCheck = false;

  meta = with lib; {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = "https://github.com/jmhobbs/terminal-parrot";
    license = licenses.mit;
    maintainers = [ maintainers.heel ];
  };
}
