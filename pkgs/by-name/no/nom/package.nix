{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "nom";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    tag = "v${version}";
    hash = "sha256-3jkHwHEuwq+KmPyDqdRsHtU4HJiBSogifufUiFpsYkI=";
  };

  vendorHash = "sha256-d5KTDZKfuzv84oMgmsjJoXGO5XYLVKxOB5XehqgRvYw=";

  ldflags = [
    "-X 'main.version=${version}'"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/guyfedwards/nom";
    changelog = "https://github.com/guyfedwards/nom/releases/tag/v${version}";
    description = "RSS reader for the terminal";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nadir-ishiguro
      matthiasbeyer
    ];
    mainProgram = "nom";
  };
}
