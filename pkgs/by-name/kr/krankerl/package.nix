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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "ChristophWurst";
    repo = "krankerl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jQe4rDhRQdTILjbgMN1Fa3O2OCJxJOr8nmKDeI1AFos=";
  };

  cargoHash = "sha256-lfW28vMxhnf6R1y82itf9dUTAtelH39Am3JYL/YlQNo=";

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
