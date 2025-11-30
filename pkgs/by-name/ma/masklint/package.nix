{
  lib,
  rustPlatform,
  fetchFromGitHub,
  shellcheck,
  ruff,
  rubocop,
  nix-update-script,
}:

let
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  pname = "masklint";
  inherit version;

  src = fetchFromGitHub {
    owner = "brumhard";
    repo = "masklint";
    rev = "v${version}";
    hash = "sha256-PhhSJwzLTMFmisrdmsRjxWDBkBr+NjIkENHjdkTeviM=";
  };

  cargoHash = "sha256-WZwl7fdy1HNKQU1zCwifoOvmFRr/fnsvmIG2wf6ILPY=";

  nativeCheckInputs = [
    shellcheck # shells
    ruff # python
    rubocop # ruby
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lint your mask targets";
    homepage = "https://github.com/brumhard/masklint";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "masklint";
  };
}
