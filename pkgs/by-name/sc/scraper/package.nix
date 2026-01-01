{
  lib,
  rustPlatform,
<<<<<<< HEAD
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scraper";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "rust-scraper";
    repo = "scraper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGYusb+8MKz4vXjZZlM+bpmrshmts+FZLjR44DyHYqg=";
  };

  cargoHash = "sha256-vbJMOVur2QE0rFo1OJkSsuNzTOzn22ty5Py3gozDEzs=";
=======
  fetchCrate,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.24.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/WdzwqwxTZiWyLV/W0nsMgVJ+o3wJU6u0gOMZva+WSM=";
  };

  cargoHash = "sha256-0k8tYJbsWRAWn7stsodC8qkzzl3O8AZ1QrQ7i/n2YzY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
<<<<<<< HEAD
    installManPage scraper/scraper.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/rust-scraper/scraper";
    changelog = "https://github.com/rust-scraper/scraper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      kachick
    ];
  };
})
=======
    installManPage scraper.1
  '';

  meta = {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
