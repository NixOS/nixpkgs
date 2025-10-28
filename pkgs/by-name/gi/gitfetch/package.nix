{
  lib,
  python3Packages,
  fetchFromGitHub,
  gh,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gitfetch";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Matars";
    repo = "gitfetch";
    tag = "v${version}";
    hash = "sha256-2cOfVv/snhluazyjwDuHEbbMq3cK+bsKYnnRmby0JDo=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    requests
    readchar
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
}
