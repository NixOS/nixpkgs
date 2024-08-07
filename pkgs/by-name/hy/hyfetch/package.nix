{
  lib,
  fetchFromGitHub,
  python3Packages,
  pciutils,
}:
python3Packages.buildPythonApplication rec {
  pname = "hyfetch";
  version = "1.99.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = "refs/tags/${version}";
    hash = "sha256-GL1/V+LgSXJ4b28PfinScDrJhU9VDa4pVi24zWEzbAk=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.typing-extensions
  ];

  # No test available
  doCheck = false;

  pythonImportsCheck = [
    "hyfetch"
  ];

  postFixup = ''
    wrapProgram $out/bin/neowofetch \
      --prefix PATH : ${lib.makeBinPath [ pciutils ]}
  '';

  meta = {
    description = "neofetch with pride flags <3";
    longDescription = ''
      HyFetch is a command-line system information tool fork of neofetch.
      HyFetch displays information about your system next to your OS logo
      in ASCII representation. The ASCII representation is then colored in
      the pattern of the pride flag of your choice. The main purpose of
      HyFetch is to be used in screenshots to show other users what
      operating system or distribution you are running, what theme or
      icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = lib.licenses.mit;
    mainProgram = "hyfetch";
    maintainers = with lib.maintainers; [
      yisuidenghua
      isabelroses
    ];
  };
}
