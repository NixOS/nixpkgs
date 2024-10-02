{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  darwin,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "hnterm";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "hnterm";
    rev = "v0.4";
    hash = "sha256-VVI45T9rGX7Cf+ZAsAiXGhMTfCU6p/MBcucDx6Hdab8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    ncurses
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
  ]);

  meta = {
    description = "Browse Hacker News interactively in your terminal";
    homepage = "https://github.com/ggerganov/hnterm";
    license = lib.licenses.mit;
    mainProgram = "hnterm";
    maintainers = with lib.maintainers; [ Br1ght0ne ];
  };
}
