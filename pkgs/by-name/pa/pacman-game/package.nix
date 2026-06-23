{
  installShellFiles,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacman-game";
  version = "0-unstable-2017-01-30";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "justinjo";
    repo = "pacman";
    rev = "974db44b655270e5a6532c309ffb0eb2d3962e99";
    hash = "sha256-2GwIv8XMbd8WZBaPp4tOblAzku49UilHmv6bG9A1y+4=";
  };

  # The upstream Makefile hardcodes clang++, which is the default compiler on
  # Darwin but not on Linux. Use the stdenv compiler so it builds everywhere.
  postPatch = ''
    substituteInPlace Makefile --replace-fail "clang++" "c++"
  '';

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    installBin pacman

    runHook postInstall
  '';

  meta = {
    description = "Command line pacman game";
    homepage = "https://github.com/justinjo/Pacman";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "pacman";
  };
})
