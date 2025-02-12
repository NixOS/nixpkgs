{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "jjui";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    tag = "v${version}";
    hash = "sha256-J6Bw7/OtKuQ28gUxc7h+gdKmt98TmNqj5XZ6kLzvg3o=";
  };

  vendorHash = "sha256-czUD0+1ZJJBpp+vYYEBBuWro6InokiPriKFyKvLSGD0=";

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
