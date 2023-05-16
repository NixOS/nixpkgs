{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-cW9Pj4dTBZ0UmHvrWpx0SREBBaEIb2aaX2cdCUdlFLw=";
  };

  cargoHash = "sha256-/xkZuGyinQdUGWix/SRtJMJ5nmpXJu39/LxJoTHnT4Q=";
=======
    sha256 = "sha256-GUN/TgAlIl9/libhA+qqYDYHhc1ZDvDymR/Ac8Mev3c=";
  };

  cargoSha256 = "sha256-u6C19QA3gMzBZIRoNDnfu1p8zkirSQKjNSQrSb8+qvs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
