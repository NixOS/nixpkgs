{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  autoreconfHook,
  bison,
  onigurumaSupport ? true,
  oniguruma,
}:

stdenv.mkDerivation rec {
  pname = "jq";
  version = "1.7.1";

  # Note: do not use fetchpatch or fetchFromGitHub to keep this package available in __bootPackages
  src = fetchurl {
    url = "https://github.com/jqlang/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
    hash = "sha256-R4ycoSn9LjRD/icxS0VeIR4NjGC8j/ffcDhz3u7lgMI=";
  };

  outputs = [
    "bin"
    "doc"
    "man"
    "dev"
    "out"
  ];

  patches = [
    # can't fetchpatch because jq is in bootstrap for darwin
    # CVE-2025-48060
    # https://github.com/jqlang/jq/commit/dc849e9bb74a7a164a3ea52f661cc712b1ffbd43
    ./0001-Improve-performance-of-repeating-strings-3272.patch

    # needed for the other patches to apply correctly
    # https://github.com/jqlang/jq/commit/b86ff49f46a4a37e5a8e75a140cb5fd6e1331384
    ./0002-fix-jv_number_value-should-cache-the-double-value-of.patch

    # CVE-2024-53427
    # https://github.com/jqlang/jq/commit/a09a4dfd55e6c24d04b35062ccfe4509748b1dd3
    ./0003-Reject-NaN-with-payload-while-parsing-JSON.patch

    # CVE-2024-23337
    # https://github.com/jqlang/jq/commit/de21386681c0df0104a99d9d09db23a9b2a78b1e
    ./0004-Fix-signed-integer-overflow-in-jvp_array_write-and-j.patch

    # CVE-2025-48060, part two
    # Improve-performance-of-repeating-strings is only a partial fix
    # https://github.com/jqlang/jq/commit/c6e041699d8cd31b97375a2596217aff2cfca85b
    ./0005-Fix-heap-buffer-overflow-when-formatting-an-empty-st.patch
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
    echo "echo ${version}" >> scripts/version
    patchShebangs scripts/version
  '';

  # paranoid mode: make sure we never use vendored version of oniguruma
  # Note: it must be run after automake, or automake will complain
  preBuild = ''
    rm -r ./modules/oniguruma
  '';

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
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}"
    # https://github.com/jqlang/jq/issues/3252
    ++ lib.optional stdenv.hostPlatform.isOpenBSD "CFLAGS=-D_BSD_SOURCE=1";

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

  postInstallCheck = ''
    $bin/bin/jq --help >/dev/null
    $bin/bin/jq -r '.values[1]' <<< '{"values":["hello","world"]}' | grep '^world$' > /dev/null
  '';

  passthru = { inherit onigurumaSupport; };

  meta = with lib; {
    description = "Lightweight and flexible command-line JSON processor";
    homepage = "https://jqlang.github.io/jq/";
    license = licenses.mit;
    maintainers = with maintainers; [
      raskin
      artturin
      ncfavier
    ];
    platforms = platforms.unix;
    downloadPage = "https://jqlang.github.io/jq/download/";
    mainProgram = "jq";
  };
}
