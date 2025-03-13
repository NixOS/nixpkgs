{
  lib,
  callPackage,
  fetchFromGitHub,
  nix,
  nix-prefetch-git,
  nixpkgs-review,
  python3Packages,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "nix-update";
    version = "1.10.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Mic92";
      repo = "nix-update";
      tag = self.version;
      hash = "sha256-fGs/EdCEoDA9N5gPtHU6CaDZo9e/aqW6pm6atsjK7PI=";
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
      nix-update-script = callPackage ./nix-update-script.nix { nix-update = self; };
    };

    meta = {
      description = "Swiss-knife for updating nix packages";
      homepage = "https://github.com/Mic92/nix-update/";
      changelog = "https://github.com/Mic92/nix-update/releases/tag/${self.version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        figsoda
        mic92
      ];
      mainProgram = "nix-update";
    };
  };
in
self
