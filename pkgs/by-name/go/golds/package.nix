{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "golds";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "go101";
    repo = "golds";
    tag = "v${version}";
    hash = "sha256-maYkVZlr8VW3nsNLVD+ib8TfltBkDrgWiC7VyeEJIy4=";
  };

  # nixpkgs is not using the go distpack archive and missing a VERSION file in the source
  # but we can use go env to get the same information
  # https://github.com/NixOS/nixpkgs/pull/358316#discussion_r1855322027
  patches = [ ./info_module-gover.patch ];

  vendorHash = "sha256-Sy9O23iCW8voImPFQkqczPxqGyD5rf0/tKxaRDFgbSs=";

  ldflags = [ "-s" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental Go local docs server/generator and code reader implemented with some fresh ideas";
    homepage = "https://github.com/go101/golds";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "golds";
  };
}
