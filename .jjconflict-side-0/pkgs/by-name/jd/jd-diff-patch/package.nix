{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner  = "josephburnett";
    repo   = "jd";
    rev    = "v${version}";
    sha256 = "sha256-qq/Y2/NGK3xsgljT0D9+dD1D1UfjB9Niay81nQJ4gX0=";
  };

  # not including web ui
  excludedPackages = [ "gae" "pack" ];

  vendorHash = null;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 blaggacao ];
    mainProgram = "jd";
  };
}
