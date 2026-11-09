{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gerrit-queue";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "flokli";
    repo = "gerrit-queue";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JkAYqqet6y89RTBU9FuxkMwJiGM6opL0reXbojSal3Y=";
  };
  vendorHash = "sha256-+Ig4D46NphzpWKXO23Haea9EqVtpda8v9zLPJkbe3bQ=";

  meta = {
    description = "Merge bot for Gerrit";
    homepage = "https://github.com/flokli/gerrit-queue";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
    mainProgram = "gerrit-queue";
  };
})
