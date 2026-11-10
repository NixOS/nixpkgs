{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rss-bridge";
  version = "2026-09-30";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = finalAttrs.version;
    sha256 = "sha256-QHIfCe6bP/m+UTC5bZUh94fxM3gAtEvWDkf3MyaGb7I=";
  };

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru = {
    tests = {
      inherit (nixosTests.rss-bridge) caddy nginx;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "RSS feed for websites missing it";
    homepage = "https://github.com/RSS-Bridge/rss-bridge";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      dawidsowa
      mynacol
    ];
    platforms = lib.platforms.all;
  };
})
