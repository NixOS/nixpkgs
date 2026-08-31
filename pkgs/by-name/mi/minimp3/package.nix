{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "minimp3";
  version = "0-unstable-2026-03-12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "lieff";
    repo = "minimp3";
    rev = "7b590fdcfa5a79c033e76eacc05d0c3e4c79f536";
    hash = "sha256-ZDYPan9f3Nx+JQpY44NmF9RkOa+MV7V0rOiPJ4pKyU0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    install -Dm644 minimp3*.h -t $out/include

    runHook postInstall
  '';

  meta = {
    description = "Minimalistic MP3 decoder single header library";
    homepage = "https://github.com/lieff/minimp3";
    license = lib.licenses.cc0;
    maintainers = [ lib.maintainers.ryand56 ];
    platforms = lib.intersectLists lib.platforms.linux (
      lib.platforms.x86 ++ lib.platforms.x86_64 ++ lib.platforms.aarch64
    );
  };
})
