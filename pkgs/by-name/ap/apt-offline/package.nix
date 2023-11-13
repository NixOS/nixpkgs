{ lib
, fetchFromGitHub
, python3Packages
, gnupg
}:

let
  pname = "apt-offline";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = "apt-offline";
    rev = "v${version}";
    hash = "sha256-RBf/QG0ewLS6gnQTBXi0I18z8QrxoBAqEXZ7dro9z5A=";
  };
in
python3Packages.buildPythonApplication {
  inherit pname version src;

  postPatch = ''
    substituteInPlace org.debian.apt.aptoffline.policy \
      --replace /usr/bin/ "$out/bin"

    substituteInPlace apt_offline_core/AptOfflineCoreLib.py \
      --replace /usr/bin/gpgv "${gnupg}/bin/gpgv"
  '';

  preFixup = ''
    rm "$out/bin/apt-offline-gui"
    rm "$out/bin/apt-offline-gui-pkexec"
  '';

  doCheck = false; # API incompatibilities, maybe?

  pythonImportsCheck = [ "apt_offline_core" ];

  meta = {
    homepage = "https://github.com/rickysarraf/apt-offline";
    description = "Offline APT package manager";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "apt-offline";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
