{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-zdn5jyb8mQ8CXHu3bHpZ7+c6K6lwoSLnmhMspMeDzy0=";
  };

  vendorHash = "sha256-iVsLJ7UcUVTg14yEdThb6HBx6XutG0m+S9OW4iiFPUE=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
