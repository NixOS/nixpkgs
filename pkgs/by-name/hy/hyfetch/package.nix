{
  lib,
  fetchFromGitHub,
  python3Packages,
  pciutils,
  installShellFiles,
}:
python3Packages.buildPythonApplication rec {
  pname = "hyfetch";
  version = "1.99.0";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    tag = version;
    hash = "sha256-GL1/V+LgSXJ4b28PfinScDrJhU9VDa4pVi24zWEzbAk=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.typing-extensions
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # No test available
  doCheck = false;

  pythonImportsCheck = [
    "hyfetch"
  ];

  # NOTE: The HyFetch project maintains an updated version of neofetch renamed
  # to "neowofetch" which is included in this package. However, the man page
  # included is still named "neofetch", so to prevent conflicts and confusion
  # we rename the file to "neowofetch" before installing it:
  postInstall = ''
    mv ./docs/neofetch.1 ./docs/neowofetch.1
    installManPage ./docs/hyfetch.1 ./docs/neowofetch.1
  '';

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
      nullcube
    ];
  };
}
