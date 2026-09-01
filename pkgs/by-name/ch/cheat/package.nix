{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cheat";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    tag = finalAttrs.version;
    sha256 = "sha256-RDfOdyQL9QICXZmgYCmz532iTuPdCW8GixajvEXmaUQ=";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  patches = [
    (builtins.toFile "fix-zsh-completion.patch" ''
      diff --git a/scripts/cheat.zsh b/scripts/cheat.zsh
      index befe1b2..675c9f8 100755
      --- a/scripts/cheat.zsh
      +++ b/scripts/cheat.zsh
      @@ -62,4 +62,4 @@ _cheat() {
         esac
       }

      -compdef _cheat cheat
      +_cheat "$@"
    '')
  ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  vendorHash = null;

  doCheck = false;

  meta = {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with lib.maintainers; [ mic92 ];
    license = with lib.licenses; [
      gpl3
      mit
    ];
    inherit (finalAttrs.src.meta) homepage;
    mainProgram = "cheat";
  };
})
