{ buildPythonApplication
, fetchFromGitHub
, lib

, waylandSupport ? true
, x11Support ? true

, ConfigArgParse
, rofi
, wl-clipboard
, wtype
, xdotool
, xsel
}:

buildPythonApplication rec {
  pname = "rofimoji";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = version;
    sha256 = "sha256-bLV0hYDjVH11euvNHUHZFcCVywuceRljkCqyX4aANVs=";
  };

  # `rofi` and the `waylandSupport` and `x11Support` dependencies
  # contain binaries needed at runtime.
  propagatedBuildInputs = with lib; [ ConfigArgParse rofi ]
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
