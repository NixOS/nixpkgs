{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "hosts-bl";
  version = "0-unstable-2024-11-17";

  src = fetchFromGitHub {
    owner = "ScriptTiger";
    repo = "Hosts-BL";
    rev = "b3ac0a50fce8e714e754a17e6a11f8709386782c";
    sha256 = "sha256-w+4dEWwFMjBbeJPOqMrzLBBzPYh/V5SfV2BMrI0p3nw=";
  };

  postPatch = ''
    go mod init github.com/ScriptTiger/Hosts-BL
  '';

  vendorHash = null;

  meta = {
    homepage = "https://github.com/ScriptTiger/Hosts-BL";
    description = "Simple tool to handle hosts file black lists";
    mainProgram = "Hosts-BL";
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
