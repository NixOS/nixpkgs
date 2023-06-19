{ lib
, stdenv
, fetchFromGitHub
, swt_jdk8
, gtk
}:

let
  swt-jdk8-gtk3 = swt_jdk8.overrideAttrs (oldAttrs: {
    gtk = gtk;
  });
in stdenv.mkDerivation rec {
  pname = "moda";
  version = "0.0.1";

  # src = fetchFromGitHub {
  #   owner = "CHANGE";
  #   repo = pname;
  #   rev = version;
  #   sha256 = "0000000000000000000000000000000000000000000000000000";
  # };

  buildInputs = [
    swt-jdk8-gtk3
  ];

  meta = with lib; {
    description = "CHANGE";
    homepage = "https://github.com/CHANGE/CHANGE";
    license = licenses.CHANGE;
    maintainers = with maintainers; [  ];
  };
}
