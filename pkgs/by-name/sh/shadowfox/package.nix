{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchpatch,
}:

buildGoModule rec {
  pname = "shadowfox";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "125mw70jidbp436arhv77201jdp6mpgqa2dzmrpmk55f9bf29sg6";
  };

  patches = [
    # get vendoring to work with go1.20
    # https://github.com/arguablykomodo/shadowfox-updater/pull/70
    (fetchpatch {
      url = "https://github.com/arguablykomodo/shadowfox-updater/commit/c16be00829373e0de7de47d6fb4d4c341fc36f75.patch";
      hash = "sha256-buijhFLI8Sf9qBDntf689Xcpr6me+aVDoRqwSIcKKEw=";
    })
  ];

  vendorHash = "sha256-3pHwyktSGxNM7mt0nPOe6uixS+bBJH9R8xqCyY6tlb0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.tag=v${version}"
  ];

  meta = with lib; {
    description = "Universal dark theme for Firefox while adhering to the modern design principles set by Mozilla";
    homepage = "https://overdodactyl.github.io/ShadowFox/";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "shadowfox-updater";
  };
}
