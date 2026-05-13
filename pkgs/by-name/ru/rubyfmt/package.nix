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
  rust-jemalloc-sys,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rubyfmt";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "fables-tales";
    repo = "rubyfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pzv51KUvDi9MyOOj/RiJus91JzU5M2IhHDoxUS4cN2I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    bison
    ruby
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zlib
    libxcrypt
    libyaml
    rust-jemalloc-sys
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    readline
    libiconv
    libunwind
  ];

  cargoHash = "sha256-Y7W3zwbScdZd+4W75od3CpwKWSxe1Bk2u2QEzgDUn/Y=";

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-fdeclspec";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    "BINDGEN_EXTRA_CLANG_ARGS_${stdenv.hostPlatform.rust.rustcTarget}" =
      "-isystem ${stdenv.cc.libc.dev}/include";
  };

  preFixup = ''
    mv $out/bin/rubyfmt{-main,}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Ruby autoformatter";
    homepage = "https://github.com/fables-tales/rubyfmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    mainProgram = "rubyfmt";
  };
})
