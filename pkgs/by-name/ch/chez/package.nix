{
  lib,
  stdenv,
  fetchFromGitHub,
  zuo,
  zlib,
  lz4,
  libffi,
  cctools,
  darwin,
  ncurses,
  libiconv,
  libX11,
  testers,
  writableTmpDirAsHomeHook,
  buildPackages,
}:
let
  inherit (stdenv.hostPlatform) extensions;

  arch =
    {
      "x86_64-linux" = "ta6le";
      "x86-linux" = "ti3le";
      "aarch64-linux" = "tarm64le";
      "x86_64-darwin" = "ta6osx";
      "aarch64-darwin" = "tarm64osx";
      "x86_64-windows" = "ta6nt";
      "aarch64-windows" = "tarm64nt";
    }
    .${stdenv.hostPlatform.system}
      or (throw "Unsupported host system, try checking https://cisco.github.io/ChezScheme/release_notes/latest/release_notes.html to see if ${stdenv.hostPlatform.system} is supported");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chez-scheme";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "ChezScheme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wAEnuC6hktCK/l00G48jYD9fwdyiXkzHjC2YYVeCJXo=";
    # Vendored nanopass and stex
    fetchSubmodules = true;
  };

  strictDeps = true;
  depsBuildBuild = [
    zuo # Used as the build driver
    buildPackages.stdenv.cc # Needed for cross
  ];
  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      darwin.autoSignDarwinBinariesHook
    ];

  buildInputs = [
    ncurses
    libiconv
    zlib
    lz4
    libffi
  ]
  ++ lib.optionals stdenv.hostPlatform.isUnix [
    libX11
  ];

  /*
    ** Set to use Nixpkgs dependencies when possible
    ** instead of vendored dependencies.
    **
    ** Carefully set a manual workarea argument, so that we
    ** can later easily find the machine type that we built Chez
    ** for.
  */
  enableParallelBuilding = true;
  dontAddPrefix = true;
  configurePlatforms = [ ]; # So it doesn't add the default --build --host flags
  configureFlags = [
    # Skip submodule update
    "--as-is"
    # Threaded version
    "--threads"
    "--installprefix=${placeholder "out"}"
    "--installman=${placeholder "out"}/share/man"
    "--enable-libffi"
    "CC_FOR_BUILD=cc"
    # Use Nixpkgs dependencies
    "ZUO=zuo"
    "ZLIB=${zlib}/lib/libz${extensions.sharedLibrary}"
    "LZ4=${lz4.lib}/lib/liblz4${extensions.sharedLibrary}"
    # Append to CFLAGS or else get errors
    # Don't set CFLAGS so it can do some detections stuff
    "CFLAGS+=${lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation"}"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross"
    "-m=${arch}"
  ];

  enableParallelChecking = true;
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  doCheck = false; # Filesystem checks are impure

  # ** Clean up some of the examples from the build output.
  postInstall = ''
    rm -rf $out/lib/csv${finalAttrs.version}/examples
  '';

  setupHook = ./setup-hook.sh;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Powerful and incredibly fast R6RS Scheme compiler";
    homepage = "https://cisco.github.io/ChezScheme/";
    changelog = "https://cisco.github.io/ChezScheme/release_notes/v${finalAttrs.version}/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      thoughtpolice
      RossSmyth
    ];
    platforms = lib.platforms.all;
    mainProgram = "scheme";
  };
})
