{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "obsidian-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "obsidian-cli";
    rev = "v${version}";
    hash = "sha256-H7Nm+QwpAD5K1Ltl4irvSI/z3Ct7g3rh2w0Rbka7LwE=";
  };

  vendorHash = null;          # repo includes vendor/
  subPackages = [ "." ];      # change to [ "cmd/obsidian-cli" ] if needed

  meta = with lib; {
    description = "Interact with an Obsidian vault from the terminal";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = licenses.mit;
    mainProgram = "obsidian-cli";
    platforms = platforms.unix;
  };
}

