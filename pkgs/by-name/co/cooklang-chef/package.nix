{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  writableTmpDirAsHomeHook,
  gitUpdater,
  withWebserver ? true,
}:
rustPlatform.buildRustPackage rec {
  pname = "cooklang-chef";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "Zheoni";
    repo = "cooklang-chef";
    tag = "v${version}";
    hash = "sha256-0Cu1fkcD8l1oea35eTv+FHwqRZxIYOCy5ytkJmSTLZc=";
  };

  cargoHash = "sha256-aTIOmO6kICQgUqiA8Pjq+sfWgaObWFw4y1l1is0HTAI=";

  # optionally disable the webserver
  buildNoDefaultFeatures = !withWebserver;

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    for s in bash fish zsh; do
      installShellCompletion --cmd chef --$s <($out/bin/chef generate-completions $s)
    done
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/Zheoni/cooklang-chef";
    description = "CLI to manage cooklang recipes with extensions";
    changelog = "https://github.com/Zheoni/cooklang-chef/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "chef";
    maintainers = [ lib.maintainers.mathematicaster ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
