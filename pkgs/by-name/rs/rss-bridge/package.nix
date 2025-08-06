{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "rss-bridge";
  version = "2025-06-03";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = version;
    sha256 = "sha256-S9TSTUwuScOcLbEpGgET1zzH1WlO1IMUOiwzMTsA65s=";
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

  meta = with lib; {
    description = "RSS feed for websites missing it";
    homepage = "https://github.com/RSS-Bridge/rss-bridge";
    license = licenses.unlicense;
    maintainers = with maintainers; [
      dawidsowa
      mynacol
    ];
    platforms = platforms.all;
  };
}
