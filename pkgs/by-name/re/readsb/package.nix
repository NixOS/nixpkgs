{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  rtl-sdr,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readsb";
  version = "3.16.3";

  src = fetchFromGitHub {
    owner = "wiedehopf";
    repo = "readsb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IjARj2qC1/kwoVvc5SXkJmoDN2m1fjPWj7jVgHG8cWI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    rtl-sdr
    zlib
    zstd
  ];

  # remove version string magic that utilizes git and current time
  postPatch = ''
    sed --in-place '/^READSB_VERSION :=/d' Makefile
  '';

  enableParallelBuilding = true;
  makeFlags = [
    # set something for version, we removed the original value in postPatch
    "READSB_VERSION=${finalAttrs.version}"
  ]
  ++ (lib.lists.optional (rtl-sdr != null) "RTLSDR=yes");

  doCheck = true;
  checkTarget = "cprtest";
  # TODO there is a crctests target in Make, it describes how to compile ./crctests, but doesn't run
  # it. Compilation also fails with:
  #
  # ld: /build/cc9NI2Fd.o: in function `malloc_or_exit':
  # > /build/source/readsb.h:407:(.text+0xbad): undefined reference to `setExit'
  #
  # Comment this test in once this has been fixed upstream.
  # postCheck = ''
  #   make crctests && ./crctests
  # '';

  installPhase = ''
    runHook preInstall

    mkdir --parent -- $out/bin
    mv readsb viewadsb $out/bin

    runHook postInstall
  '';

  meta = {
    description = "ADS-B decoder swiss knife";
    homepage = "https://github.com/wiedehopf/readsb";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.linux; # uses epoll, hence its linux only
  };
})
