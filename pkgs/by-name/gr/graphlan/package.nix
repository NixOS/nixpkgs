{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "graphlan";
  version = "1.1.3-unstable-2024-08-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "graphlan";
    rev = "dc97f4feb0bb0bf3fa210e2699a86c5e476a647e";
    hash = "sha256-sBVlBu6RSs7dXQbxJrIQHWaDNliurY9UguzNeKj40gY=";
  };

  patchPhase = ''
    sed -i 's|biopython==|biopython>=|' setup.py
  '';

  __structuredAttrs = true;
  strictDeps = true;
  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    biopython
    matplotlib
    scipy
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Quality control tool for metagenomic and metatranscriptomic sequencing data";
    homepage = "https://github.com/biobakery/graphlan";
    changelog = "https://github.com/biobakery/graphlan/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "graphlan.py";
  };
}
