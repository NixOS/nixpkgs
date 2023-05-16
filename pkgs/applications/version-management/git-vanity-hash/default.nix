{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "git-vanity-hash";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "2020-02-26-unstable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "git-vanity-hash";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-jD8cSFXf9UNBZ9d8JTnuwhs6nPHY/xGd5RyqF+mQOlo=";
  };

  cargoHash = "sha256-8oW6gRtdQdmSmdwKlcU2EhHsyhk9hFhKl7RtsYwC7Ps=";
=======
    rev = "000004122124005af8d118a3f379bfc6ecc1e7c7";
    sha256 = "1wf342zawbphlzvji0yba0qg4f6v67h81nhxqcsir132jv397ma7";
  };

  cargoSha256 = "1frdw9bs7y6ch5rrbsgvhrs0wxw4hbwm2n3crslp12w55m7k39fc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
