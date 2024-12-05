{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  version = "0.3.2";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "intentrace";

  src = fetchFromGitHub {
    owner = "sectordistrict";
    repo = "intentrace";
    rev = "refs/tags/v${version}";
    hash = "sha256-MVOQQfHQZtHJX/JEdCMxosyiUzSN1yjmuUkpwE7Fn4Y=";
  };

  cargoHash = "sha256-Bq5YsOf/saUH5xn6RhSzp50yH8cyBJ3JClPmRBkM5rg=";

  meta = {
    description = "Prettified Linux syscall tracing tool (like strace)";
    homepage = "https://github.com/sectordistrict/intentrace";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "intentrace";
    maintainers = with lib.maintainers; [
      cloudripper
      jk
    ];
  };
}
