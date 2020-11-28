{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "git-vanity-hash";
  version = "2020-02-26-unstable";

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "git-vanity-hash";
    rev = "000004122124005af8d118a3f379bfc6ecc1e7c7";
    sha256 = "1wf342zawbphlzvji0yba0qg4f6v67h81nhxqcsir132jv397ma7";
  };

  cargoSha256 = "0mbdis1kxmgj3wlgznr9bqf5yv0jwlj2f63gr5c99ja0ijccp99h";

  postInstall = ''
    mkdir -p $out/share/doc/git-vanity-hash
    cp README.md $out/share/doc/git-vanity-hash
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/prasmussen/git-vanity-hash";
    description = "Tool for creating commit hashes with a specific prefix";
    license = [ licenses.mit ];
    maintainers = [ maintainers.kaction ];
  };
}
