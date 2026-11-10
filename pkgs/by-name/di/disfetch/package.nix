{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "disfetch";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = finalAttrs.version;
    sha256 = "sha256-xzOE+Pnx0qb3B9vWWrF5Q0nhUo0QYBUO6j6al8N3deY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin disfetch
    runHook postInstall
  '';

  meta = {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/q60/disfetch";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vel ];
    mainProgram = "disfetch";
  };
})
