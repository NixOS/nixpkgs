{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

# Although we copy in the udev rules here, you probably just want to use
# logitech-udev-rules instead of adding this to services.udev.packages on NixOS

stdenv.mkDerivation rec {
  pname = "ltunify";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Lekensteyn";
    repo = "ltunify";
    rev = "v${version}";
    sha256 = "sha256-9avri/2H0zv65tkBsIi9yVxx3eVS9oCkVCCFdjXqSgI=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "bindir=/bin"
  ];

  meta = with lib; {
    description = "Tool for working with Logitech Unifying receivers and devices";
    longDescription = ''
      This tool requires either to be run with root/sudo or alternatively to have the udev rules files installed. On NixOS this can be achieved by setting `hardware.logitech.wireless.enable`.
    '';
    homepage = "https://lekensteyn.nl/logitech-unifying.html";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "ltunify";
  };
}
