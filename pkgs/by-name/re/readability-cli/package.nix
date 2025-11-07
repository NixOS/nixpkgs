{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitLab,
  installShellFiles,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "readability-cli";
  version = "2.4.5";

  src = fetchFromGitLab {
    owner = "gardenappl";
    repo = "readability-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fkXhAXbvCj5eRkPcv0Q7ryZeGdERI/lHHg64EDyK2F4=";
  };

  patches = [
    ./lockfile.patch
  ];

  postPatch = ''
    # Set a script name to avoid yargs using index.js as $0
    substituteInPlace common.mjs \
      --replace-fail '.version(false)' '.version(false).scriptName("readable")'
  '';

  npmDepsHash = "sha256-9sN1TgyOjgGLQsAlnI/fVbez7Oy2r6QwfaUTKyLQRVc=";

  nativeBuildInputs = [ installShellFiles ];

  dontNpmBuild = true;

  postInstall = ''
    installManPage readability-cli.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd readable \
      --bash <(SHELL=bash $out/bin/readable --completion) \
      --zsh <(SHELL=zsh $out/bin/readable --completion)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Firefox Reader Mode in your terminal - get useful text from a web page using Mozilla's Readability library";
    homepage = "https://gitlab.com/gardenappl/readability-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ juliusfreudenberger ];
    mainProgram = "readable";
  };
})
