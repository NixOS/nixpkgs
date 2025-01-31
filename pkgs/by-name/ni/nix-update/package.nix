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
    version = "1.7.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Mic92";
      repo = "nix-update";
      rev = "refs/tags/${self.version}";
      hash = "sha256-5KhS3RxeVDHKjsxT3hHtl0hHcwlSHl2fYFYLonobpLg=";
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
      homepage = "https://github.com/Mic92/nix-update/";
      description = "Swiss-knife for updating nix packages";
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
