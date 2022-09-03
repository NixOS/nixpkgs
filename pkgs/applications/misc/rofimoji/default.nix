{ buildPythonApplication
, fetchFromGitHub
, lib

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
  version = "5.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = "refs/tags/${version}";
    sha256 = "sha256-rYqEeAoHCx0j83R1vmtj+CVuR0QFEd3e1c5O454mANM=";
  };

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

  # no tests executed
  doCheck = false;

  meta = with lib; {
    description = "A simple emoji and character picker for rofi";
    homepage = "https://github.com/fdw/rofimoji";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
