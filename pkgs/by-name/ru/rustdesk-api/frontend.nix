{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "rustdesk-api-web";
  version = "0-unstable-2025-08-31";
  src = fetchFromGitHub {
    owner = "lejianwen";
    repo = "rustdesk-api-web";
    rev = "3998c2a9213fcd047252776d0f0db33e6717026c";
    hash = "sha256-qmt+u0elgZo04NhTUJeoEopEad0soPiQeosxZseHgos=";
  };
  npmDepsHash = "sha256-W9p8nf4ppBUsNFweh/aGC6ZU9Kwrwwmf2HYBe4PfgBU=";
  patches = [ ./normalize-locale.patch ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r dist/. "$out/"
    runHook postInstall
  '';
  meta = {
    description = "Administration frontend for RustDesk API";
    homepage = "https://github.com/lejianwen/rustdesk-api-web";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xiongchenyu6 ];
    platforms = lib.platforms.all;
  };
}
