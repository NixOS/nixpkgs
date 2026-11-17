{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  dbus,
  sqlite,
  file,
  libgit2,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "krankerl";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "ChristophWurst";
    repo = "krankerl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ms3i8b2y3tnQUGrjZpnifB5e8JP3vQC+IicwZ67pIJY=";
  };

  cargoHash = "sha256-c6/0l2aik7MKOfqhwk1Tp6jTZST7vjG6gNM03DP/nGg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
    libgit2
  ];

  nativeCheckInputs = [
    file
  ];

  meta = {
    description = "CLI helper to manage, package and publish Nextcloud apps";
    mainProgram = "krankerl";
    homepage = "https://github.com/ChristophWurst/krankerl";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
  };
})
