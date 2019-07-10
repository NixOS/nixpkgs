{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "writefreely-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "writeas";
    repo = "writefreely";
    rev = "v${version}";
    sha256 = "1nnxba549nqcv9pmldkf42yggipxrwbx914anrh4wx5c128yjgbs";
  };

  modSha256 = "0n95awrf2a63z3qf3y2y7snmw0pfgzn6aliqdp6y03r7ipdqs9ij";

  meta = with lib; {
    description = "A simple, federated blogging platform";
    homepage = https://writefreely.org;
    license = licenses.agpl3;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
