{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  cmake,
  pkg-config,

  fmt,
  lzo,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "ntfs2btrfs";
  version = "20240115";

  src = fetchFromGitHub {
    owner = "maharmstone";
    repo = "ntfs2btrfs";
    tag = version;
    hash = "sha256-sZ8AWREe2jasy3hqLTjaLcOMCNsrDjz2eIuknA2TsEs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fmt
    lzo
    zlib
    zstd
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool which does in-place conversion of Microsoft's NTFS filesystem to the open-source filesystem Btrfs";
    homepage = "https://github.com/maharmstone/ntfs2btrfs";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ j1nxie ];
    mainProgram = "ntfs2btrfs";
    platforms = lib.platforms.linux;
  };
}
