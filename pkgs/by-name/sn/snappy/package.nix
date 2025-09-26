{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "snappy";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = version;
    hash = "sha256-bMZD8EI9dvDGupfos4hi/0ShBkrJlI5Np9FxE6FfrNE=";
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
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/snappy/reenable-rtti.patch?rev=e3449869b466869fc6b8a03a1a528fa6";
      hash = "sha256-JhVhkHh7XPx1Bzf5xnOgWLgwh1oihX3O+emQWzE4Dho=";
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
    substituteInPlace "$out"/lib/cmake/Snappy/SnappyTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES "'$dev'"'

    mkdir -p $dev/lib/pkgconfig
    cat <<EOF > $dev/lib/pkgconfig/snappy.pc
      Name: snappy
      Description: Fast compressor/decompressor library.
      Version: ${version}
      Libs: -L$out/lib -lsnappy
      Cflags: -I$dev/include
    EOF
  '';

  #checkTarget = "test";

  # requires gbenchmark and gtest but it also installs them out $dev
  doCheck = false;

  meta = with lib; {
    homepage = "https://google.github.io/snappy/";
    license = licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = platforms.all;
  };
}
