<<<<<<< HEAD
{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.3";
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lqFhLCOLiuSQWhbcZUEj2xFRlZ+x1ZTVc8IJw7tJjhE=";
  };

  cargoHash = "sha256-3hrpg2cMvIuFy6mH1/1igIpU4nbzFQLCAhiIRZbTuaI=";

  # fixes `thread 'main' panicked at 'cannot find strip'` on x86_64-darwin
  env = lib.optionalAttrs (stdenv.isx86_64 && stdenv.isDarwin) {
    TARGET_STRIP = "${stdenv.cc.targetPrefix}strip";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';
=======
    sha256 = "sha256-WUv0F7etmJFNRnHXkQ5G3p/5BWL30kfSYnxXYpAdo+I=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-0JJpGSOwayPB3cn7OpBjsOiK4WQNbil3gYrfkqG2cS8=";

  checkFlags = [
    # failure: path::tests::test_relative_to_parent
    "--skip=path::tests::test_relative_to_parent"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
<<<<<<< HEAD
    changelog = "https://github.com/sayanarijit/xplr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g mimame figsoda ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g mimame ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
