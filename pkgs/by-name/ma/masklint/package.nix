{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  withShell ? true,
  shellcheck,
  withPython ? true,
  ruff,
  withRuby ? true,
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

  nativeBuildInputs = [ makeWrapper ];

  postInstall = (
    if (withShell || withPython || withRuby) then
      ''
        wrapProgram $out/bin/masklint \
          --prefix PATH : ${
            lib.makeBinPath (
              (lib.optional withShell shellcheck)
              ++ (lib.optional withPython ruff)
              ++ (lib.optional withRuby rubocop)
            )
          }
      ''
    else
      ""
  );

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
