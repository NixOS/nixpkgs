{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-2DWb6PIYT9VfJeqbZ9+E1jk/xJ2+h0GARKF6XWdMhkI=";
  };

  vendorSha256 = "sha256-RQNthtPYuOSCenA0hs5EhybimrftjEJlQNkfnKGXTiM=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
