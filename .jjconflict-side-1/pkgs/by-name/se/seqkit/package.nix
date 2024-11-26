{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "seqkit";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
    sha256 = "sha256-xPlqS0tYx077YD/MIxGFn8Bdy4h25dY8idhypIj28rI=";
  };

  vendorHash = "sha256-EzEomz9GVcirx+Uk1Ygmmb1/GkdUS9aBStLxuNzjHAU=";

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
