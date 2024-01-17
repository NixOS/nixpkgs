{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  name = "pyfa";
  version = "2.57.3";
  src = fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
    hash = "sha256-IS+yYYn+aRh8QxCMmlQjV1ysR1rSmPgRSa+2+gKtw5c=";
  };
  extraPkgs = pkgs: with pkgs; [
    libnotify
    pcre2
  ];

  meta = with lib; {
    changelog = "https://github.com/pyfa-org/Pyfa/releases/tag/${version}";
    description = "Python Fitting Assistant";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pacificviking ];
  };
}
