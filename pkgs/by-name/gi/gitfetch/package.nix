{
  lib,
  python3Packages,
  fetchFromGitHub,
  gh,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitfetch";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Matars";
    repo = "gitfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dVJdc0iqcl/+s3v+ui6XtKRlOuYoFVYWlG0GtTZLr5o=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    requests
    readchar
    webcolors
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        gh
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Neofetch-style CLI tool for git provider statistics";
    homepage = "https://github.com/Matars/gitfetch";
    mainProgram = "gitfetch";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
