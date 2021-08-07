{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "kratos";
  version = "0.7.1-alpha.1";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
    sha256 = "0n0qjnwavr34g8b6vr000wgpbnmyq7n1grcy79cvzdrnc8jxkgxi";
  };

  vendorSha256 = "14x2flimhvd2wdkajvsm5bqbqikgirynzxs27mzlx0bvhliv247s";

  subPackages = [ "." ];

  tags = [ "sqlite" ];

  doCheck = false;

  preBuild = ''
    # Patch shebangs
    files=(
       test/e2e/run.sh
       script/testenv.sh
       script/test-envs.sh
       persistence/sql/migratest/update_fixtures.sh
    )
    patchShebangs "''${files[@]}"

    # patchShebangs doesn't work for this Makefile, do it manually
    substituteInPlace Makefile --replace '/bin/bash' '${stdenv.shell}'
  '';

  meta = with lib; {
    maintainers = with maintainers; [ mrmebelman ];
    homepage = "https://www.ory.sh/kratos/";
    license = licenses.asl20;
    description = "An API-first Identity and User Management system that is built according to cloud architecture best practices";
  };
}
