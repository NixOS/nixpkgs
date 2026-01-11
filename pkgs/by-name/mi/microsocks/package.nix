{
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "microsocks";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = "microsocks";
    rev = "v${version}";
    hash = "sha256-5NR2gtm+uMkjmkV/dv3DzSedfNvYpHZgFHVSrybl0Tk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm 755 microsocks -t $out/bin/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rofl0r/microsocks/releases/tag/v${version}";
    description = "Tiny, portable SOCKS5 server with very moderate resource usage";
    homepage = "https://github.com/rofl0r/microsocks";
    license = lib.licenses.mit;
    mainProgram = "microsocks";
    maintainers = with lib.maintainers; [ ramblurr ];
  };
}
