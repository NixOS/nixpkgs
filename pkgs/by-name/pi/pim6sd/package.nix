{
  stdenv,
  fetchFromGitHub,
  lib,
  autoreconfHook,
  bison,
  flex,
}:

stdenv.mkDerivation {
  pname = "pim6sd";
  version = "0-unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "pim6sd";
    rev = "9fd332d92af4fe8c92a70c1b6c2048ffddb0e48a";
    hash = "sha256-iTukxjo63Smk6wX8SQsi49iNLpmxeN9JSkBZB5aBMaQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
  ];

  meta = {
    description = "PIM for IPv6 sparse mode daemon";
    homepage = "https://github.com/troglobit/pim6sd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pim6sd.x86_64-darwin
  };
}
