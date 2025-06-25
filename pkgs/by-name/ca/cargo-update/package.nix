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

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "16.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VKXEbgm3Oc4rq/F2p/kuhhhiyKvLU6KHnKnQMBX17XU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AXYcDxKQ9p4deolcZFO5SmfwnQGxl1I03RK6tSTbjlo=";

  nativeBuildInputs =
    [
      cmake
      installShellFiles
      pkg-config
      ronn
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
    ];

  buildInputs =
    [
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
    changelog = "https://github.com/nabijaczleweli/cargo-update/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerschtli
      Br1ght0ne
      johntitor
      matthiasbeyer
    ];
  };
}
