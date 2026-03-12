{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  autoconf,
  automake,
  bison,
  ruby,
  zlib,
  readline,
  libiconv,
  libunwind,
  libxcrypt,
  libyaml,
  rust-jemalloc-sys-unprefixed,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rubyfmt";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "fables-tales";
    repo = "rubyfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGvfmBm2GNXASXc//K2JOrn/iUdlbA5dDReNJ+NqjDM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    bison
    ruby
  ];

  buildInputs = [
    zlib
    libxcrypt
    libyaml
    rust-jemalloc-sys-unprefixed
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    readline
    libiconv
    libunwind
  ];

  preConfigure = ''
    pushd librubyfmt/ruby_checkout
    autoreconf --install --force --verbose
    ./configure
    popd
  '';

  cargoPatches = [
    # Avoid checking whether ruby gitsubmodule is up-to-date.
    ./0002-remove-dependency-on-git.patch
    # Avoid failing on unused variable warnings.
    ./0003-ignore-warnings.patch
  ];

  cargoHash = "sha256-jJa/6TKwTTN3xOBuUy+YdwKOJbtYVrmlHgMyqPCVqVs=";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-fdeclspec";

  preFixup = ''
    mv $out/bin/rubyfmt{-main,}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Ruby autoformatter";
    homepage = "https://github.com/fables-tales/rubyfmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "rubyfmt";
  };
})
