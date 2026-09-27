{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

# Native (Rust) fileshare library consumed by nordvpn-linux's cgo bindings
# (github.com/NordSecurity/libdrop-go), which are already vendored as a Go
# dependency. Only the compiled `libnorddrop.so` is needed here -- the cgo
# header ships inside the libdrop-go module itself.
rustPlatform.buildRustPackage rec {
  pname = "libdrop";
  version = "9.0.0"; # keep in sync with LIBDROP_VERSION in nordvpn-linux's lib-versions.env

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libdrop";
    tag = "v${version}";
    hash = "sha256-SGS8RCfIM42wglKI2pBHRocuGkT/9TsyxC5ftexPZQ4=";
  };

  cargoHash = "sha256-trRj485fa/ShsIx+oyjgR1GImCG5Zw0sZz0oHkZe4iU=";

  # drop-storage links against system libsqlite3 rather than bundling it
  buildInputs = [ sqlite ];

  # norddrop's build.rs falls back to `git rev-parse HEAD` for its version
  # string unless this is set; fetchFromGitHub doesn't keep .git, so `git`
  # would otherwise fail outright.
  env.LIBDROP_RELEASE_NAME = "v${version}";

  # only build the `norddrop` workspace member (the cdylib); other members
  # (drop-analytics, drop-transfer, ...) are its internal dependencies and
  # get pulled in transitively
  buildAndTestSubdir = ".";
  cargoBuildFlags = [
    "-p"
    "norddrop"
  ];

  doCheck = false;

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
}
