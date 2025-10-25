{
  lib,
  fetchpatch2,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "cotton";
  version = "0-unstable-2025-08-24";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = "cotton";
    rev = "43eb56f8d0228b63f26a48491980d4e91e965b8e";
    hash = "sha256-GF5RtQmzPCDp5H1EW5rl+GDr2/xKA9zrjOeYyCdBtmI=";
  };

  cargoPatches = [
    (fetchpatch2 {
      name = "Fix-CVE-2025-62518";
      url = "https://github.com/danielhuang/cotton/commit/586fb861e9cef540dd3973210d82923436b8bc4b.patch?full_index=1";
      hash = "sha256-6cwiiTsC3R63qJpPKRh8AzrCWFufBM32ThAJGYZDQdo=";
    })
  ];

  cargoHash = "sha256-XrFG3ixHV6/IPnAVTfPjWFrXdSWQjCPkGWD8tj9LGVY=";

  meta = with lib; {
    description = "Package manager for JavaScript projects";
    mainProgram = "cotton";
    homepage = "https://github.com/danielhuang/cotton";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      dit7ya
      figsoda
    ];
  };
}
