{ lib
, python3Packages
, fetchFromGitHub
, installShellFiles

, waylandSupport ? true
, x11Support ? true

, rofi
, wl-clipboard
, wtype
, xdotool
, xsel
}:

python3Packages.buildPythonApplication rec {
  pname = "rofimoji";
  version = "6.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = "refs/tags/${version}";
    hash = "sha256-gYLUUbT6OHMo2nzJ//Pa0vZ9WPcHs6YnAjTKNO07VNk=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
    installShellFiles
  ];

  # `rofi` and the `waylandSupport` and `x11Support` dependencies
  # contain binaries needed at runtime.
  propagatedBuildInputs = [ python3Packages.configargparse rofi ]
    ++ lib.optionals waylandSupport [ wl-clipboard wtype ]
    ++ lib.optionals x11Support [ xdotool xsel ];

  # The 'extractors' sub-module is used for development
  # and has additional dependencies.
  postPatch = ''
    rm -rf extractors
  '';

  postInstall = ''
    installManPage src/picker/docs/rofimoji.1
  '';

  meta = with lib; {
    description = "A simple emoji and character picker for rofi";
    mainProgram = "rofimoji";
    homepage = "https://github.com/fdw/rofimoji";
    changelog = "https://github.com/fdw/rofimoji/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
