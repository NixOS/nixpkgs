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
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l6EvOXUZcbx712WYN3L4y8Qdim9sEISH06CWxgav6cQ=";
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
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      mdaniels5757
      mic92
    ];
    mainProgram = "nix-update";
  };
})
