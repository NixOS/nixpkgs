{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  cmake,
  dbus,
  liblsl,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comlsldd";
  version = "0-unstable-2026-06-29";

  src = fetchFromCodeberg {
    owner = "Pandapip1";
    repo = "comlsldd";
    rev = "ff049524c883350c42307d00339dabf8dec08951";
    hash = "sha256-GvKOylQrlDQZ9bw6WIXJBf4Pkrnd3m/hSvnClJKiw3k=";
  };

  cargoHash = "sha256-HmcG2pzgfZIdBecvDtTnmFPSOr414u5v1PncTvvNO+s=";

  separateDebugInfo = true;
  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    dbus
    liblsl
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://codeberg.org/Pandapip1/comlsldd";
    description = "COMmon LSL Driver Daemon";
    mainProgram = "comlsldd";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})
