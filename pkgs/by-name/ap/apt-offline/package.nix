{
  lib,
  fetchFromGitHub,
  python3Packages,
  gnupg,
  installShellFiles,
}:

let
  pname = "apt-offline";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = "apt-offline";
    tag = "v${version}";
    hash = "sha256-PnU8vbEY+EpEv8D6Ap/iJqfwOWxpNytT+XDFCFD8XqU=";
  };
in
python3Packages.buildPythonApplication {
  format = "setuptools";
  inherit pname version src;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace org.debian.apt.aptoffline.policy \
      --replace-fail /usr/bin/ "$out/bin"

    substituteInPlace apt_offline_core/AptOfflineCoreLib.py \
      --replace-fail /usr/bin/gpgv "${lib.getBin gnupg}/bin/gpgv"
  '';

  postInstall = ''
    installManPage apt-offline.8
  '';

  postFixup = ''
    rm "$out/bin/apt-offline-gui" "$out/bin/apt-offline-gui-pkexec"
  '';

  doCheck = false; # API incompatibilities, maybe?

  pythonImportsCheck = [ "apt_offline_core" ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "https://github.com/rickysarraf/apt-offline";
    description = "Offline APT package manager";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "apt-offline";
    maintainers = with lib.maintainers; [ ];
  };
}
# TODO: verify GUI and pkexec
