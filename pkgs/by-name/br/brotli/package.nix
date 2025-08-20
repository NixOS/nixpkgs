{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  staticOnly ? stdenv.hostPlatform.isStatic,
  testers,
}:

# ?TODO: there's also python lib in there

stdenv.mkDerivation (finalAttrs: {
  pname = "brotli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MvceRcle2dSkkucC2PlsCizsIf8iv95d8Xjqew266wc=";
  };

  patches = [
    # revert runpath change, breaks curl on darwin:
    #   https://github.com/NixOS/nixpkgs/pull/254532#issuecomment-1722337476
    (fetchpatch {
      name = "revert-runpath.patch";
      url = "https://github.com/google/brotli/commit/f842c1bcf9264431cd3b15429a72b7dafbe80509.patch";
      hash = "sha256-W3LY3EjoHP74YsKOOcYQrzo+f0HbooOvEbnOibtN6TM=";
      revert = true;
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

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm and tool";
    longDescription = ''
      Brotli is a generic-purpose lossless compression algorithm that
      compresses data using a combination of a modern variant of the LZ77
      algorithm, Huffman coding and 2nd order context modeling, with a
      compression ratio comparable to the best currently available
      general-purpose compression methods. It is similar in speed with
      deflate but offers more dense compression.

      The specification of the Brotli Compressed Data Format is defined
      in the following internet draft:
      http://www.ietf.org/id/draft-alakuijala-brotli
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
    pkgConfigModules = [
      "libbrotlidec"
      "libbrotlienc"
    ];
    platforms = platforms.all;
    mainProgram = "brotli";
  };
})
