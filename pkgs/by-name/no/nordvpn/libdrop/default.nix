{
  fetchFromGitHub,
  lib,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libdrop";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libdrop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGS8RCfIM42wglKI2pBHRocuGkT/9TsyxC5ftexPZQ4=";
  };

  buildInputs = [ sqlite ];

  cargoHash = "sha256-trRj485fa/ShsIx+oyjgR1GImCG5Zw0sZz0oHkZe4iU=";

  doCheck = true;

  env = {
    LIBDROP_RELEASE_NAME = "v${finalAttrs.version}";
  };

  meta = {
    description = "NordVPN's filesharing library.";
    homepage = "https://github.com/NordSecurity/libdrop";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      different-error
      novalkun
    ];
    platforms = lib.platforms.linux;
  };
})
