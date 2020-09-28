{ stdenv, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "0x6msbbqkwxs6msqacpqw4wlw7c9ilf8n6jqmx297ij6isswgksh";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
