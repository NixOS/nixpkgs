{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "kratos";
  version = "0.6.0-alpha.2";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
    sha256 = "0zg6afzqi5fmr7hmy1cd7fknd1bcplz3h0f7z67l75v8k2n73md1";
  };

  vendorSha256 = "16qg44k97l6719hib8vbv0j15x6gvs9d6738d2y990a2qiqbsqpw";

  subPackages = [ "." ];

  buildFlags = [ "-tags sqlite" ];

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
