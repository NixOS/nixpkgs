{ lib, buildGoModule, fetchFromGitHub, testers }:

buildGoModule (finalAttrs: {
  pname = "obsidian-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "obsidian-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H7Nm+QwpAD5K1Ltl4irvSI/z3Ct7g3rh2w0Rbka7LwE=";
  };

  vendorHash = null;
  subPackages = [ "." ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    description = "Interact with an Obsidian vault from the terminal";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = lib.licenses.mit;
    mainProgram = "obsidian-cli";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
