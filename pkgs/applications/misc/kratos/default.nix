{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "kratos";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ory";
    repo = "kratos";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KDpc0zc65rvvpPojghFEujoS0aewyjv7B/bmpC2i1dA=";
  };

  vendorHash = "sha256-Y/Sd2hu1bPUb0TQRD1pANz+rtqKcHBXvjKpYwKgxHMQ=";
=======
    hash = "sha256-Ld2N7w9jQLkzCww1Sex5nEBZf6e9XIUnbfPOjcFAYQA=";
  };

  vendorSha256 = "sha256-9zXoJ+c1aPWDqasechC4ModWE0+sfMqZzp/Pph/mYcs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  tags = [ "sqlite" ];

  doCheck = false;

  preBuild = ''
    # Patch shebangs
    files=(
       test/e2e/run.sh
       script/testenv.sh
       script/test-envs.sh
       script/debug-entrypoint.sh
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
