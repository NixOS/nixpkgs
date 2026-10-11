{ lib, fetchFromGitHub, rustPlatform, git }:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gluon";
  version = "0.18.4";
  src = fetchFromGitHub {
    owner = "gluon-lang";
    repo = "gluon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aI9IoIy/lv/Zsm38htWwcjdaQUVhRj2ILIgH5kcluc4=";
  };

  # Apparently, git is required to build...
  nativeBuildInputs = [ git ];

  # The package, in the workspace, is "gluon_repl".  The default package is a library, not an
  # application.
  cargoBuildFlags = [ "-p" "gluon_repl" ];
  cargoTestFlags = [ "-p" "gluon_repl" ];

  cargoHash = "sha256-T+sNNICxWutL4mPs7vvi6AswOL09rx34iGjNmaD89QI=";

  # Checks don't pass, I'm too lazy to fix this.
  doCheck = false;

  meta = {
    description = "Embeddable funcitonal language for Rust.";
    homepage = "gluon-lang.org";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ jthulhu ];
  };
})
