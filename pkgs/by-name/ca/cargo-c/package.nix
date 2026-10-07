{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  libgit2,
  libz,
  sqlite,
  openssl,
  stdenv,
  libiconv,
  rav1e,
}:

let
  # this version may need to be updated along with package version
  cargoVersion = "0.96.0";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-c";
  version = "0.10.22";

  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname;
    version = "${finalAttrs.version}+cargo-${cargoVersion}";
    hash = "sha256-yqSrpBZUa0NmsPawYKKgywmbbG4zgguwfDF667s7zdo=";
  };

  cargoHash = "sha256-yeJWZtkgCRB0ipyTslsGcJi9Fi/XoWziuv74exRhAIk=";

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = 1;
    LIBZ_SYS_STATIC = 0;
  };

  nativeBuildInputs = [
    pkg-config
    (lib.getDev curl)
  ];
  buildInputs = [
    libgit2
    libz
    sqlite
    openssl
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      inherit rav1e;
    };
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cpu
      matthiasbeyer
    ];
  };
})
