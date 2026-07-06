{
  lib,
  callPackage,
  fetchFromGitHub,
  nix,
  nix-prefetch-git,
  nixpkgs-review,
  python3Packages,
  nix-update,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nix-update";
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LT66e5NtAJRp0E8QXKeePdTCNpH+CMvJNF1ayzBr4rw=";
  };

  build-system = [ python3Packages.setuptools ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      nix
      nix-prefetch-git
      nixpkgs-review
    ])
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/nix-update --help >/dev/null

    runHook postCheck
  '';

  passthru = {
    nix-update-script = callPackage ./nix-update-script.nix { inherit nix-update; };
  };

  meta = {
    description = "Swiss-knife for updating nix packages";
    homepage = "https://github.com/Mic92/nix-update/";
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      mdaniels5757
      mic92
    ];
    mainProgram = "nix-update";
  };
})
