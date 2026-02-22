{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gemget";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "gemget";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-P5+yRaf2HioKOclJMMm8bJ8/BtBbNEeYU57TceZVqQ8=";
  };

  vendorHash = "sha256-l8UwkFCCNUB5zyhlyu8YC++MhmcR6midnElCgdj50OU=";

  meta = {
    description = "Command line downloader for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/gemget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amfl ];
    mainProgram = "gemget";
  };
})
