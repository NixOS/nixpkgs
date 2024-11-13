{
  buildGoModule,
  bzip2,
  callPackage,
  cbconvert,
  fetchFromGitHub,
  fetchpatch2,
  imagemagick,
  lib,
  libunarr,
  mupdf-headless,
  nix-update-script,
  pkg-config,
  testers,
  zlib,
}:

buildGoModule rec {
  pname = "cbconvert";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "gen2brain";
    repo = "cbconvert";
    rev = "v${version}";
    hash = "sha256-9x7RXyiQoV2nIVFnG1XHcYfTQiMZ88Ck7uuY7NLK8CA=";
  };

  # Update dependencies in order to use the extlib tag.
  patches = [
    (fetchpatch2 {
      name = "update-dependencies-1.patch";
      url = "https://github.com/gen2brain/cbconvert/commit/1a36ec17b2c012f278492d60d469b8e8457a6110.patch";
      hash = "sha256-E+HWYPz9FtU3JAktzIRflF/pHdLfoaciBmjb7UOQYLo=";
    })
    (fetchpatch2 {
      name = "update-dependencies-2.patch";
      url = "https://github.com/gen2brain/cbconvert/commit/74c5de699413e95133f97666b64a1866f88fedd5.patch";
      hash = "sha256-rrJsYJHcfNWF90vwUAT3J/gqg22e1gk6I48LsTrYbmU=";
    })
  ];

  vendorHash = "sha256-aVInsWvygNH+/h7uQs4hAPOO2gsSkBx+tI+TK77M/hg=";
  modRoot = "cmd/cbconvert";

  proxyVendor = true;

  # The extlib tag forces the github.com/gen2brain/go-unarr module to use external libraries instead of bundled ones.
  tags = [ "extlib" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    imagemagick
    libunarr
    mupdf-headless
    zlib
  ];

  passthru = {
    gui = callPackage ./gui.nix { };
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = cbconvert;
      command = "cbconvert version";
    };
  };

  meta = {
    description = "Comic Book converter";
    homepage = "https://github.com/gen2brain/cbconvert";
    changelog = "https://github.com/gen2brain/cbconvert/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "cbconvert";
  };
}
