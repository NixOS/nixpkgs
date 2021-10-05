{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "kratos";
  version = "0.7.6-alpha.1";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
    sha256 = "1412jckfsm0d5gn7fhjpj212xbsf43sfpd8hgcz3pxc0q37dzfgh";
  };

  vendorSha256 = "1gcdahs8x26kpwlng3wijqi12yjwj19v413wyyviim4vn1r4c0m7";

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
