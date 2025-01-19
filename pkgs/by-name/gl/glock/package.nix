{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "glock";
  version = "0-unstable-2021-03-19";

  src = fetchFromGitHub {
    owner = "robfig";
    repo = "glock";
    rev = "0ac7e52a4c8a9a7039a72b3c6a10e8be59bc6599";
    hash = "sha256-EDaLk83u1gRcvEjrfBrLZBQZ5unyD9LQA2TccOawXII=";
  };

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/robfig/glock/commit/943afe5e26dd64ebad5ca17613ae3700c53fb25d.patch";
      hash = "sha256-nk+5uHlCv7Hxbo0Axvi15nJVzEcb++gOJpF3w06yQsk=";
    })
  ];

  vendorHash = "sha256-v3lfb+CXbTxzObDpubufD3Q1h6IhULcC/6spA6StfGw=";

  checkFlags = [ "-skip=^TestSave$" ];

  meta = {
    homepage = "https://github.com/robfig/glock";
    description = "Command-line tool to lock Go dependencies to specific revisions";
    mainProgram = "glock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      rushmorem
    ];
  };
}
