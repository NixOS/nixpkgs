{ lib, buildGoPackage, fetchFromGitHub, wrapXiFrontendHook }:

buildGoPackage rec {
  bname = "kod";
  name = "kod-unstable-${version}";
  version = "2018-10-16";
  rev = "146fef39a44868c01ba4cb2b1a2ba18a90f1df06";

  goPackagePath = "github.com/linde12/kod";

  src = fetchFromGitHub {
    owner = "linde12";
    repo = "kod";
    inherit rev;
    sha256 = "0lavfivwlk1ga0xf237dxmdax06gs030a005xx1rdy1a3sy77bdg";
  };

  goDeps = ./deps.nix;

  buildInputs = [ wrapXiFrontendHook ];

  postInstall = "wrapXiFrontend $bin/bin/*";

  meta = with lib; {
    description = "terminal text editor written in Go, using xi-editor as backend";
    homepage = https://github.com/linde12/kod;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
