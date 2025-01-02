{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "jjui";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    rev = "v${version}";
    hash = "sha256-MdSzY2JWL34qB13mX4FWG/4wzl30FmATYQ09N1v5Isc=";
  };

  vendorHash = "sha256-pzbOFXSlEebc4fCyNyQSdeVqar+HfEjsSyJo+mHkQeg=";

  postFixup = ''
    mv $out/bin/cmd $out/bin/jjui
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "jjui";
  };
}
