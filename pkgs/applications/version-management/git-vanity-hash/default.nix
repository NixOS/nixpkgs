{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "git-vanity-hash";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "git-vanity-hash";
    rev = "v${version}";
    hash = "sha256-jD8cSFXf9UNBZ9d8JTnuwhs6nPHY/xGd5RyqF+mQOlo=";
  };

  cargoHash = "sha256-8oW6gRtdQdmSmdwKlcU2EhHsyhk9hFhKl7RtsYwC7Ps=";

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
