{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "realm";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "zhboner";
    repo = "realm";
    rev = "v${version}";
    hash = "sha256-vkLGfSDRYqvoqyVM/CWGJjpvXXPisEZxUSjLZGjNzno=";
  };

  cargoHash = "sha256-Oe64l16uYdU6NvTl7XrEm6dAtRFngI9yHC4fe4hpTNA=";

  env.RUSTC_BOOTSTRAP = 1;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) realm; };
  };

  meta = with lib; {
    description = "Simple, high performance relay server written in rust";
    homepage = "https://github.com/zhboner/realm";
    mainProgram = "realm";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox ];
  };
}
