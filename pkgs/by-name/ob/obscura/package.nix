{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  versionCheckHook,
  _experimental-update-script-combinators,
}:

let
  librusty_v8 = callPackage ./librusty_v8.nix { };
in
rustPlatform.buildRustPackage rec {
  pname = "obscura";
  __structuredAttrs = true;
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "h4ckf0r0day";
    repo = "obscura";
    rev = "v${version}";
    hash = "sha256-6IhZhKUlwR06JYTDhQL1Sd1uamVG5PJn4CLxmXyfxEk=";
  };

  cargoHash = "sha256-db6UEtuncxOUlFzFLdfkk3DyFbEcldxYDKaKPrPS75g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests crash in Nix sandbox: all obscura-js tests create a V8 isolate
  # via deno_core::JsRuntime::new(), which loads the pre-built librusty_v8
  # binary. The sandbox's user namespace + resource limits are incompatible
  # with V8's initialization.
  # Basic CLI operations (--help, fetch) don't create an isolate, so work fine.
  doCheck = false;

  # --version doesn't create a V8 isolate, so this runs fine in the sandbox
  # where the tests (see above) crash.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    RUSTY_V8_ARCHIVE = librusty_v8;
    # Upstream never bumps the workspace Cargo.toml version per release (still
    # 0.1.0 at the v0.1.10 tag); obscura-cli/build.rs only reports the git tag
    # on GitHub Actions and otherwise falls back to CARGO_PKG_VERSION. Pin it
    # here so `obscura --version` matches the packaged release.
    OBSCURA_VERSION = version;
  };

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update.sh
    ];
    inherit librusty_v8;
  };

  meta = with lib; {
    description = "Headless browser for AI agents and web scraping";
    homepage = "https://github.com/h4ckf0r0day/obscura";
    license = licenses.asl20;
    maintainers = with maintainers; [ dhogenson ];
    mainProgram = "obscura";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
