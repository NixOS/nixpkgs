{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "rss-bridge";
  version = "2024-02-02";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = version;
    sha256 = "sha256-VycEgu7uHYwDnNE1eoVxgaWZAnC6mZLBxT8Le3PI4Rs=";
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
