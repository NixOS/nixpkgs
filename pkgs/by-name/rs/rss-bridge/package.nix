{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rss-bridge";
  version = "2025-08-05";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = finalAttrs.version;
    sha256 = "sha256-SH5iYsdvGD51j+2xqaG51VDtb35m1v9MR0+yLE1eyWo=";
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
