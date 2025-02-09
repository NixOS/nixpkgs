{ buildPythonApplication
, fetchFromGitHub
, lib
, python3
, installShellFiles

, waylandSupport ? true
, x11Support ? true

, configargparse
, rofi
, wl-clipboard
, wtype
, xdotool
, xsel
}:

buildPythonApplication rec {
  pname = "rofimoji";
  version = "6.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = "refs/tags/${version}";
    sha256 = "sha256-eyzdTMLW9nk0x74T/AhvoVSrxXugc1HgNJy8EB5BApE=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    installShellFiles
  ];

  # `rofi` and the `waylandSupport` and `x11Support` dependencies
  # contain binaries needed at runtime.
  propagatedBuildInputs = with lib; [ configargparse rofi ]
    ++ optionals waylandSupport [ wl-clipboard wtype ]
    ++ optionals x11Support [ xdotool xsel ];

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
    homepage = "https://github.com/fdw/rofimoji";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
