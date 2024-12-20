{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "plistwatch";
  version = "unstable-2023-06-22";

  src = fetchFromGitHub {
    owner = "catilac";
    repo = "plistwatch";
    rev = "34d808c1509eea22fe88a2dbb6f0a1669a2a5b23";
    hash = "sha256-kMHi5xKbiwO+/6Eb8oJz7ECoUybFE+IUDz7VfJueB3g=";
  };

  vendorHash = "sha256-Layg1axFN86OFgxEyNFtIlm6Jtx317jZb/KH6IjJ8e4=";

  #add missing dependencies and hashes
  patches = [ ./go-modules.patch ];

  doCheck = false;

  meta = with lib; {
    description = "Monitors and prints changes to MacOS plists in real time";
    homepage = "https://github.com/catilac/plistwatch";
    maintainers = with maintainers; [ gdinh ];
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
