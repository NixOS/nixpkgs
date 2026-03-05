{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "doge";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Olivia5k";
    repo = "doge";
    tag = finalAttrs.version;
    hash = "sha256-Bvk6LZT4H5ge+n/CuUI42d3OXOxZfHp+kGG74o10yac=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    python-dateutil
    fullmoon
  ];

  meta = {
    description = "Wow very terminal doge";
    longDescription = ''
      Doge is a simple motd script based on the slightly stupid but very funny doge meme.
      It prints random grammatically incorrect statements that are sometimes based on things from your computer.
    '';
    homepage = "https://github.com/Olivia5k/doge";
    license = lib.licenses.mit;
    mainProgram = "doge";
    maintainers = with lib.maintainers; [
      Gonzih
      quantenzitrone
    ];
  };
})
