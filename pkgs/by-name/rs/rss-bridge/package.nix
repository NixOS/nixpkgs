{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "rss-bridge";
  version = "2025-01-02";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = version;
    sha256 = "sha256-6Ise+qptY2wLkNveT/mzL0nWrX6OhxAlOJkF2+BmSTE=";
  };

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru = {
    tests = {
      basic-functionality = nixosTests.rss-bridge;
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
