{
  lib,
  stdenv,
  fetchFromGitHub,
  bluez,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "bluelog";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "MS3FGX";
    repo = pname;
    tag = version;
    hash = "sha256-Si/uqZ3P0KzrU9jstfkwMj2/1yHGBO1HkNWNbU/99dk=";
  };

  buildInputs = [ bluez ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/MS3FGX/Bluelog";
    description = "A highly configurable Linux Bluetooth scanner with optional web interface.";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/MS3FGX/Bluelog/releases/tag/${version}";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
