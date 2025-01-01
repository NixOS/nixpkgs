{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "golds";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "go101";
    repo = "golds";
    tag = "v${version}";
    hash = "sha256-ExvCVGWYAngasnDHVzBLeLmms4cFNcQ/KzuE4t3r36A=";
  };

  # nixpkgs is not using the go distpack archive and missing a VERSION file in the source
  # but we can use go env to get the same information
  # https://github.com/NixOS/nixpkgs/pull/358316#discussion_r1855322027
  patches = [ ./info_module-gover.patch ];

  vendorHash = "sha256-omjHRZB/4VzPhc6RrFY11s6BRD69+Y4RRZ2XdeKbZf0=";

  ldflags = [ "-s" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    description = "Experimental Go local docs server/generator and code reader implemented with some fresh ideas";
    homepage = "https://github.com/go101/golds";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "golds";
  };
}
