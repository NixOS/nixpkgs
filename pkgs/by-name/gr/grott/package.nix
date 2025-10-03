{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "2.8.3";
  versionSuffix = "-unstable-2025-05-27";
in
python3Packages.buildPythonApplication {
  pname = "grott";
  version = "${version}${versionSuffix}";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johanmeijer";
    repo = "grott";
    rev = "fb52e2d4ff3065f60db45a7c2c82f2ad7e9f8463";
    hash = "sha256-q521T9KZz/QhbSOyNAFsftUZeMLaW/pjmGCJgk2j0Rs=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  postPatch = ''
    cat > pyproject.toml <<'EOF'
      [build-system]
      requires = ["setuptools"]
      build-backend = "setuptools.build_meta"

      [project]
      name = "grott"
      version = "${version}"
      dependencies = [
          "paho-mqtt",
          "requests",
      ]

      [project.scripts]
      grott = "grott.__main__:main"

      [tool.setuptools.packages.find]
      where = ["."]

      [tool.setuptools]
      py-modules = [
          "grott",
          "grottconf",
          "grottdata",
          "grottproxy",
          "grottserver",
          "grottsniffer",
      ]
    EOF

    find .
    echo
    echo pyproject.toml:
    cat pyproject.toml
    # exit 1
  '';

  pythonPath = with python3Packages; [
    paho-mqtt
    requests
    # libscrc # optional; not packaged in nixpkgs yet
  ];

  pythonImportsCheck = [
    "grott"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Growatt inverter monitor";
    homepage = "https://github.com/johanmeijer/grott";
    license = lib.licenses.unfree; # see https://github.com/johanmeijer/grott/issues/512
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nh2 ];
  };
}
