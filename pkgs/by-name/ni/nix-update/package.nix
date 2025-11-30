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

python3Packages.buildPythonApplication rec {
  pname = "nix-update";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
    tag = version;
    hash = "sha256-b/Ymvz4Un67j7UulzBJtmKrwcchpEE/si/QOn/m8m80=";
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
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      mic92
    ];
    mainProgram = "nix-update";
  };
}
