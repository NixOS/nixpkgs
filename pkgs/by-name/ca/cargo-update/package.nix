{
  lib,
  rustPlatform,
  fetchCrate,
  cmake,
  installShellFiles,
  pkg-config,
  ronn,
  stdenv,
  curl,
  libgit2,
  libssh2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-update";
  version = "22.1.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-aq6l2tDWwvARdRgFJ1dTrWnh4XSy8uM32GdACVtzjQ8=";
  };

  cargoHash = "sha256-3OfxeVPWd2v0/A2945/MZgwTBpEcfH3ql1oMVTsjNBY=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    ronn
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  postBuild = ''
    # Man pages contain non-ASCII, so explicitly set encoding to UTF-8.
    HOME=$TMPDIR \
    RUBYOPT="-E utf-8:utf-8" \
      ronn -r --organization="cargo-update developers" man/*.md
  '';

  postInstall = ''
    installManPage man/*.1
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = {
    description = "Cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    changelog = "https://github.com/nabijaczleweli/cargo-update/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerschtli
      johntitor
      matthiasbeyer
    ];
  };
})
