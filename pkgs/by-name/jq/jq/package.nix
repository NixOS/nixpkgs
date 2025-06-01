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
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jq";
  version = "1.8.0";

  # Note: do not use fetchpatch or fetchFromGitHub to keep this package available in __bootPackages
  src = fetchurl {
    url = "https://github.com/jqlang/jq/releases/download/jq-${finalAttrs.version}/jq-${finalAttrs.version}.tar.gz";
    hash = "sha256-kYEVd/kdmmGV/1DCv/7JtyyEKdwF7D6gIv2VwG0rMZw=";
  };

  outputs = [
    "bin"
    "doc"
    "man"
    "dev"
    "out"
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

  configureFlags =
    [
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
  nativeInstallCheckInputs = [ versionCheckHook ];

  preInstallCheck = ''
    substituteInPlace tests/shtest \
      --replace-fail "TZ=" "TZ=${tzdata}/share/zoneinfo/"
  '';

  postInstallCheck = ''
    $bin/bin/jq -r '.values[1]' <<< '{"values":["hello","world"]}' | grep '^world$' > /dev/null
  '';

  passthru = {
    inherit onigurumaSupport;
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      raskin
      artturin
      ncfavier
    ];
    platforms = lib.platforms.unix;
    downloadPage = "https://jqlang.github.io/jq/download/";
    mainProgram = "jq";
  };
})
