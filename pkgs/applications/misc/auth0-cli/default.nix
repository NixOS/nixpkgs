{ lib
, buildGoModule
, fetchFromGitHub
, runCommand
, testers
, auth0-cli
}:

buildGoModule rec {
  pname = "auth0-cli";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = pname;
    rev = "v${version}";
    sha256 = "15vjqhrrbcg1za3vrshygan1kmp0d14xnffhfr0kix27nz6z442d";
  };

  vendorSha256 = "0r20snd45cq4lwzq8kxqmnbd6s0aqfd4sblijfrpc2a2189shp8s";

  preBuild = ''
      substituteInPlace ./Makefile \
        --replace "\$(shell git describe --abbrev=0)" "v${version}" \
        --replace "\$(shell git rev-parse --short HEAD)" "v${version}" \
        --replace "\$(shell git rev-parse --verify --abbrev-ref HEAD)" "v${version}" \
        --replace "\$(shell git status --porcelain --untracked-files=no)" ""
    '';

  buildPhase = ''
      runHook preBuild

      make build

      runHook postBuild
    '';

  checkPhase = ''
      make test
    '';

  passthru.tests.version = testers.testVersion {
    package = auth0-cli;
    command = "auth0 --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Supercharge your developer workflow. 🚀";
    homepage = "https://github.com/auth0/auth0-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ "poita66" ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
