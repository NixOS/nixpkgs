{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusty-bash";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "shellgei";
    repo = "rusty_bash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WBV0wF7SKhOKAo+F1IImpPIgLvo9GYkqWrb2GluUtdA=";
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
})
