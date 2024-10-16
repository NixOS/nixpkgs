{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
  git,
}:

buildGoModule rec {
  pname = "garble";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = "garble";
    rev = "refs/tags/v${version}";
    hash = "sha256-FtI5lAeqjRPN47iC46bcEsRLQb7mItw4svsnLkRpNxY=";
  };

  vendorHash = "sha256-mSdajYiMEg2ik0ocfmHK+XddEss1qLu6rDwzjocaaW0=";

  # Used for some of the tests.
  nativeCheckInputs = [ git ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [
      davhau
      bot-wxt1221
    ];
    license = lib.licenses.bsd3;
  };
}
