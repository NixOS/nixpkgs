{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
  static ? stdenv.hostPlatform.isStatic,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snappy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = finalAttrs.version;
    hash = "sha256-QVBzdVdQAHOBD7wwbOncYNbA4unRgTLI2Xac9RjERM4=";
  };

  patches = [
    ./revert-PUBLIC.patch
    # Re-enable RTTI, without which other applications can't subclass snappy::Source
    # While the patch was rejected upstream, it does not make it any less necessary to carry forward.
    # ==> lack of RTTI *breaks* Ceph (and others) <==
    #
    # https://tracker.ceph.com/issues/53060
    # https://build.opensuse.org/package/show/openSUSE:Factory/snappy
    #
    # Should this patch fail to apply use the above site to get the updated patch (rev in the url below).
    # On the page there's a "latest revision" section which lists the last request which was merged into it.
    # Click the "Request <insert number>" link, then view any file using "View file", and copy the rev from your address bar.
    # For a different revision (in case nixpkgs is behind or something) you can go through the full revision history.
    # Should the patch not be available for the nixpkgs version, ideally wait until the patch becomes available before bumping, or vendor it if necessary.
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/snappy/reenable-rtti.patch?rev=26dd9a294fdef957239de93ca330c878";
      hash = "sha256-ao/pWrDNJdtDCfWBEmeUV3tPWRS8l95X9o+hTaSjiVk=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DSNAPPY_BUILD_TESTS=OFF"
    "-DSNAPPY_BUILD_BENCHMARKS=OFF"
  ];

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    cat <<EOF > $dev/lib/pkgconfig/snappy.pc
      Name: snappy
      Description: Fast compressor/decompressor library.
      Version: ${finalAttrs.version}
      Libs: -L$out/lib -lsnappy
      Cflags: -I$dev/include
    EOF
  '';

  passthru.updateScript = nix-update-script { };

  #checkTarget = "test";

  # requires gbenchmark and gtest but it also installs them out $dev
  doCheck = false;

  meta = {
    homepage = "https://google.github.io/snappy/";
    license = lib.licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = lib.platforms.all;
  };
})
