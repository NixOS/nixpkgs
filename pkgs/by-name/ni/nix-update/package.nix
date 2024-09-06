{ lib
, python3
, fetchFromGitHub
, nix
, nix-prefetch-git
, nixpkgs-review
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-update";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JXls4EgMDAWtd736nXS2lYTUv9QIjRpkCTimxNtMN7Q=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nix nix-prefetch-git nixpkgs-review ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help >/dev/null
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    changelog = "https://github.com/Mic92/nix-update/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mic92 ];
    mainProgram = "nix-update";
    platforms = platforms.all;
  };
}
