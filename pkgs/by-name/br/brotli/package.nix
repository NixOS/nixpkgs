{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  python3Packages,
  staticOnly ? stdenv.hostPlatform.isStatic,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brotli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kl8ZHt71v17QR2bDP+ad/5uixf+GStEPLQ5ooFoC5i8=";
  };

  patches = [
    # Fixes build on LoongArch64 & IA64
    # https://github.com/google/brotli/commit/e230f474b87134e8c6c85b630084c612057f253e
    (fetchurl {
      url = "https://github.com/google/brotli/commit/e230f474b87134e8c6c85b630084c612057f253e.patch";
      hash = "sha256-QERl8RHJz7tFr++hZIYwdj1/ogPpjArC+ia8S/bWxKk=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional staticOnly "-DBUILD_SHARED_LIBS=OFF";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  doCheck = true;

  checkTarget = "test";

  # Don't bother with "man" output for now,
  # it currently only makes the manpages hard to use.
  postInstall = ''
    mkdir -p $out/share/man/man{1,3}
    cp ../docs/*.1 $out/share/man/man1/
    cp ../docs/*.3 $out/share/man/man3/
  '';

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      python = python3Packages.brotli;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/google/brotli";
    changelog = "https://github.com/google/brotli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "General-purpose lossless compression library with CLI";
    longDescription = ''
      Brotli is a generic-purpose lossless compression algorithm that
      compresses data using a combination of a modern variant of the LZ77
      algorithm, Huffman coding and 2nd order context modeling, with a
      compression ratio comparable to the best currently available
      general-purpose compression methods. It is similar in speed with
      deflate but offers more dense compression.

      The specification of the Brotli Compressed Data Format is defined
      in the following Internet-Draft:
      https://datatracker.ietf.org/doc/html/rfc7932
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    pkgConfigModules = [
      "libbrotlidec"
      "libbrotlienc"
    ];
    platforms = lib.platforms.all;
    mainProgram = "brotli";
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "google" finalAttrs.version;
  };
})
