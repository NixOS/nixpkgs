{ pkgs, lib }:

pkgs.buildGoModule rec {
  pname = "find_dc";
  version = "1.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "0xthefr34k";
    repo = "find_dc";
    rev = "v${version}";
    hash = "sha256-rPw0H2jlCyeAKGLCR1Gvisv+hHCCmyRWi1k+i5zzxTg=";  # Replace with correct hash
  };

  vendorHash = null;  # No vendor dependencies

  meta = {
    description = "find_dc is a Go-based tool to process nxc output and find domain controllers.";
    homepage = "https://github.com/0xthefr34k/find_dc";
    license = pkgs.lib.licenses.mit;
    maintainers = [ "0xthefr34k" ];
    platforms = lib.platforms.all;
  };
}

