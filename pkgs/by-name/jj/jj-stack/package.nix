{
  lib,
  buildNpmPackage,
  stdenv,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jj-stack";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "keanemind";
    repo = "jj-stack";
    rev = "v${version}";
    sha256 = "sha256-fk+FZv4lu+noM6ig4NFGAlRy4AWdEjkLIDZZ877bKLs=";
  };

  npmDepsHash = "sha256-RVOnxdzSpgyxfS+EZS1oIlX+chUl8GyLXKrmVlEmLPg=";

  meta = {
    description = "Stacked PRs on GitHub for Jujutsu";
    homepage = "https://github.com/keanemind/jj-stack";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ozkutuk ];
  };
}
