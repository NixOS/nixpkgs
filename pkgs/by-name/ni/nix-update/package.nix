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
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.13.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-l6EvOXUZcbx712WYN3L4y8Qdim9sEISH06CWxgav6cQ=";
=======
    tag = version;
    hash = "sha256-b/Ymvz4Un67j7UulzBJtmKrwcchpEE/si/QOn/m8m80=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
