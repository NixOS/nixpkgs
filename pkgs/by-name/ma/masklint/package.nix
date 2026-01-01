{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  makeWrapper,
  withShell ? true,
  shellcheck,
  withPython ? true,
  ruff,
  withRuby ? true,
  rubocop,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

let
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
rustPlatform.buildRustPackage {
  pname = "masklint";
  inherit version;

  src = fetchFromGitHub {
    owner = "brumhard";
    repo = "masklint";
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    hash = "sha256-Dku2pDUCblopHtoj6viUqHVpVH5GDApp+QLjor38j7g=";
  };

  cargoHash = "sha256-TDk7hEZ628iUnKI0LMBtsSAVNF6BGukHwB8kh70eo4U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
