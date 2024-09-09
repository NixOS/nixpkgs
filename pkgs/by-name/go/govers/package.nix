{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "govers";
  version = "0-unstable-2016-06-23";

  src = fetchFromGitHub {
    owner = "rogpeppe";
    repo = "govers";
    rev = "77fd787551fc5e7ae30696e009e334d52d2d3a43";
    sha256 = "sha256-lpc8wFKAB+A8mBm9q3qNzTM8ktFS1MYdIvZVFP0eiIs=";
  };

  vendorHash = null;

  postPatch = ''
    go mod init github.com/rogpeppe/govers
  '';

  dontRenameImports = true;

  doCheck = false; # fails, silently

  meta = {
    description = "Tool for rewriting Go import paths";
    homepage = "https://github.com/rogpeppe/govers";
    license = lib.licenses.bsd3;
    mainProgram = "govers";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      urandom
    ];
  };
}
