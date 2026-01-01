{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
<<<<<<< HEAD
  version = "0.15.1";
=======
  version = "0.14.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tgDhIM8Dw4k/ocXa3U1xqS/TDmqNbjnNzIyCxEmu294=";
  };

  cargoHash = "sha256-XOy8sm6nzmihFYsgLcusoYKwgTvx0qX8o8XWV4EMXZ8=";
=======
    hash = "sha256-itD9d+EqEdJ2bTJEpHxJCFFS8Mpc7AFQ1JgkNQxncV0=";
  };

  cargoHash = "sha256-58EnGouq8iKkgsvyHqARoQ0u4QXjw0m6pv4Am4J9wlU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };

  passthru.tests = {
    basic-functioniality = nixosTests.routinator;
  };
}
