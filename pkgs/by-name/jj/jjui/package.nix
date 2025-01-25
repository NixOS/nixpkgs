{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "jjui";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-V2HwVpZ7K7mYoZECOc+dfXuvBlRsN5OgRHasdpX+kFw=";
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
