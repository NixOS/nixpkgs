{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gerrit-queue";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "flokli";
    repo = "gerrit-queue";
    rev = "v${version}";
    hash = "sha256-JkAYqqet6y89RTBU9FuxkMwJiGM6opL0reXbojSal3Y=";
  };
  vendorHash = "sha256-+Ig4D46NphzpWKXO23Haea9EqVtpda8v9zLPJkbe3bQ=";

  meta = with lib; {
    description = "Merge bot for Gerrit";
    homepage = "https://github.com/flokli/gerrit-queue";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
    mainProgram = "gerrit-queue";
  };
}
