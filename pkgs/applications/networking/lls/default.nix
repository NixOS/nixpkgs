{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    rev = "v${version}";
    hash = "sha256-FtRPRR+/R3JTEI90mAEHFyhqloAbNEdR3jkquKa9Ahw=";
  };

  cargoSha256 = "sha256-yjRbg/GzCs5d3zXL22j5U9c4BlOcRHyggHCovj4fMIs=";

  meta = with lib; {
    description = "Tool to list listening sockets";
    license = licenses.mit;
    maintainers = [ maintainers.k900 ];
    platforms = platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
  };
}
