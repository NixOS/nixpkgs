{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-r/aWzSn/Dci69oS/yopG6Ro34U8hniHVanctyM7RvDw=";
  };

  cargoHash = "sha256-IV1ftsRyM0CUlQMVmLip1FiqnouT5TsKASpF/KLARqY=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
