{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "git-vanity-hash";
  version = "2020-02-26-unstable";

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "git-vanity-hash";
    rev = "000004122124005af8d118a3f379bfc6ecc1e7c7";
    sha256 = "1wf342zawbphlzvji0yba0qg4f6v67h81nhxqcsir132jv397ma7";
  };

  cargoSha256 = "0780aiic3mrkmacr9il13w636xrx2jidxdmp7sb7hjnc6v3mqv6q";

  postInstall = ''
    mkdir -p $out/share/doc/git-vanity-hash
    cp README.md $out/share/doc/git-vanity-hash
  '';

  meta = with lib; {
    homepage = "https://github.com/prasmussen/git-vanity-hash";
    description = "Tool for creating commit hashes with a specific prefix";
    license = [ licenses.mit ];
    maintainers = [ maintainers.kaction ];
  };
}
