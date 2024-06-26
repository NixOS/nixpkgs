{ lib
, fetchFromGitHub
, python3Packages
, gnupg
, installShellFiles
}:

let
  pname = "apt-offline";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = "apt-offline";
    rev = "v${version}";
    hash = "sha256-KkJwQ9EpOSJK9PaM747l6Gqp8Z8SWvuo3TJ+Ry6d0l4=";
  };
in
python3Packages.buildPythonApplication {
  inherit pname version src;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace org.debian.apt.aptoffline.policy \
      --replace /usr/bin/ "$out/bin"

    substituteInPlace apt_offline_core/AptOfflineCoreLib.py \
      --replace /usr/bin/gpgv "${lib.getBin gnupg}/bin/gpgv"
  '';

  postInstall = ''
    installManPage apt-offline.8
  '';

  postFixup = ''
    rm "$out/bin/apt-offline-gui" "$out/bin/apt-offline-gui-pkexec"
  '';

  doCheck = false; # API incompatibilities, maybe?

  pythonImportsCheck = [ "apt_offline_core" ];

  outputs = [ "out" "man" ];

  meta = {
    homepage = "https://github.com/rickysarraf/apt-offline";
    description = "Offline APT package manager";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "apt-offline";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
# TODO: verify GUI and pkexec
