{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libdrop";
  # nixpkgs-update: no auto update
  version = "9.0.0"; # keep in sync with LIBDROP_VERSION in nordvpn-linux's lib-versions.env
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libdrop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGS8RCfIM42wglKI2pBHRocuGkT/9TsyxC5ftexPZQ4=";
  };

  cargoHash = "sha256-trRj485fa/ShsIx+oyjgR1GImCG5Zw0sZz0oHkZe4iU=";

  buildInputs = [ sqlite ];

  env.LIBDROP_RELEASE_NAME = "v${finalAttrs.version}";

  # only build the main library
  buildAndTestSubdir = ".";
  cargoBuildFlags = [
    "-p"
    "norddrop"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$(find target -name libnorddrop.so -path '*/release/*' | head -1)" -t $out/lib
    runHook postInstall
  '';

  meta = {
    description = "Native fileshare library used by NordVPN's meshnet feature";
    homepage = "https://github.com/NordSecurity/libdrop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ novalkun ];
    platforms = lib.platforms.linux;
  };
})
