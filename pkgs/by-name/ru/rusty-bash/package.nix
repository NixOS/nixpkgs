{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-bash";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "shellgei";
    repo = "rusty_bash";
    tag = "v${version}";
    hash = "sha256-hUMkgsWlGSqOnYdFhDGBWbc13oAssklbuJAg8NkY398=";
  };

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  passthru.shellPath = "/bin/sush";

  meta = {
    description = "Bash written with Rust, a.k.a. sushi shell";
    homepage = "https://github.com/shellgei/rusty_bash";
    license = lib.licenses.bsd3;
    mainProgram = "sush";
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
