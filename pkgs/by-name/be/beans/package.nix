{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "beans";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "hmans";
    repo = "beans";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JDw7zz/ZQnBz7hb5DsuBFgeBJJCl8/EhVp9Z3//ky0Y=";
  };

  vendorHash = "sha256-6S+BihxnpZSifoR+JKhOomfGcPtgNc6XXoQhSmPRL2Q=";

  meta = {
    description = "Issue tracker for you, your team, and your coding agents";
    homepage = "https://github.com/hmans/beans";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sleroq ];
    mainProgram = "beans";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
