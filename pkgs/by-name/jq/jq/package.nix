{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  autoreconfHook,
  bison,
  onigurumaSupport ? true,
  oniguruma,
  tzdata,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jq";
  version = "1.8.1";

  # Note: do not use fetchpatch or fetchFromGitHub to keep this package available in __bootPackages
  src = fetchurl {
    url = "https://github.com/jqlang/jq/releases/download/jq-${finalAttrs.version}/jq-${finalAttrs.version}.tar.gz";
    hash = "sha256-K+ZOcSnOyxHVkGKQ66EK9pT7nj5/n8IIoxHcM8qDfrA=";
  };

  outputs = [
    "bin"
    "doc"
    "man"
    "dev"
    "out"
  ];

  patches = [
    ./musl.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    # needed because epoch conversion test here is right at the end of 32 bit integer space
    # See also: https://github.com/jqlang/jq/blob/859a8073ee8a21f2133154eea7c2bd5e0d60837f/tests/optional.test#L15-L18
    # "-D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64" would be preferrable, but breaks with dynamic linking,
    # unless done globally in stdenv for all of 32 bit.
    ./disable-end-of-epoch-conversion-test.patch
  ];

  # https://github.com/jqlang/jq/issues/2871
  postPatch = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace Makefile.am --replace-fail "tests/mantest" "" --replace-fail "tests/optionaltest" ""
  '';

  # Upstream script that writes the version that's eventually compiled
  # and printed in `jq --help` relies on a .git directory which our src
  # doesn't keep.
  preConfigure = ''
    echo "#!/bin/sh" > scripts/version
    echo "echo ${finalAttrs.version}" >> scripts/version
    patchShebangs scripts/version
  '';

  # paranoid mode: make sure we never use vendored version of oniguruma
  # Note: it must be run after automake, or automake will complain
  preBuild = ''
    rm -r ./vendor/oniguruma
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = lib.optionals onigurumaSupport [ oniguruma ];
  nativeBuildInputs = [
    removeReferencesTo
    autoreconfHook
    bison
  ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--sbindir=\${bin}/bin"
    "--datadir=\${doc}/share"
    "--mandir=\${man}/share/man"
  ]
  ++ lib.optional (!onigurumaSupport) "--with-oniguruma=no"
  # jq is linked to libjq:
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}";

  # jq binary includes the whole `configureFlags` in:
  # https://github.com/jqlang/jq/commit/583e4a27188a2db097dd043dd203b9c106bba100
  # Strip unnecessary dependencies here to reduce closure size and break the
  # dependency cycle: $dev also refers to $bin via propagated-build-outputs
  postFixup = ''
    remove-references-to \
      -t "$dev" \
      -t "$man" \
      -t "$doc" \
      "$bin/bin/jq"
  '';

  doInstallCheck = true;
  installCheckTarget = "check";

  preInstallCheck = ''
    substituteInPlace tests/shtest \
      --replace-fail "TZ=" "TZ=${tzdata}/share/zoneinfo/"
  '';

  postInstallCheck = ''
    $bin/bin/jq -r '.values[1]' <<< '{"values":["hello","world"]}' | grep '^world$' > /dev/null
  '';

  passthru = {
    inherit onigurumaSupport;
    tests.version = testers.testVersion {
      package = lib.getBin finalAttrs.finalPackage;
      command = "jq --version";
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "jq-(.+)"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/jqlang/jq/releases/tag/jq-${finalAttrs.version}";
    description = "Lightweight and flexible command-line JSON processor";
    homepage = "https://jqlang.github.io/jq/";
    downloadPage = "https://jqlang.github.io/jq/download/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
      artturin
      ncfavier
      jk
    ];
    platforms = lib.platforms.unix;
    mainProgram = "jq";
  };
})
