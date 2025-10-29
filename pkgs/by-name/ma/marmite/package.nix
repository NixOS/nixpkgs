{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "marmite";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "rochacbruno";
    repo = "marmite";
    tag = version;
    hash = "sha256-4FH9WEVTvnu0gp006tBg511bn8LE6AyHOML4tHoqXeM=";
  };

  cargoHash = "sha256-wl2/feheYOYPzVElwt3WDZuaQrmoi3OoThYF4PINWd4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Static Site Generator for Blogs";
    homepage = "https://github.com/rochacbruno/marmite";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "marmite";
  };
}
