{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nasmSupport ? true,
  nasm, # Assembly optimizations
  cpmlSupport ? true, # Compaq's fast math library
  #, efenceSupport ? false, libefence # Use ElectricFence for malloc debugging
  sndfileFileIOSupport ? false,
  libsndfile, # Use libsndfile, instead of lame's internal routines
  analyzerHooksSupport ? true, # Use analyzer hooks
  decoderSupport ? true, # mpg123 decoder
  libmpg123,
  frontendSupport ? true, # Build the lame executable
  #, mp3xSupport ? false, gtk1 # Build GTK frame analyzer
  mp3rtpSupport ? false, # Build mp3rtp
  debugSupport ? false, # Debugging (disables optimizations)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lame";
  version = "4.0";

  src = fetchurl {
    url = "mirror://sourceforge/lame/lame-${finalAttrs.version}.tar.gz";
    hash = "sha256-PfUSTVrTqYMS/9e6aps2Iw5Pij5m084PQl4zbDLSFus=";
  };

  outputs = [
    "out"
    "lib"
    "doc"
  ]; # a small single header
  outputMan = "out";

  patches = [
    # fix ID3v2 UTF-8 tag path to avoid incompatible-pointer-types
    # with GCC 15; upstream SVN r6562, SF bug #524
    ./fix-utf8-id3-tag.patch
    # setlocale() is used under HAVE_LANGINFO_H, but <locale.h> was only
    # included together with HAVE_ICONV, breaking the build on macOS;
    # upstream SVN r6590
    ./fix-setlocale-without-iconv.patch
    # hip_set_pinfo/hip_finish_pinfo are used by the frontend but were missing
    # from the exported symbol list, breaking the link with analyzer hooks
    # enabled; upstream SVN r6564, SF bug #515
    ./export-hip-pinfo-symbols.patch
  ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optional nasmSupport nasm;

  buildInputs = lib.optional decoderSupport libmpg123 ++ lib.optional sndfileFileIOSupport libsndfile;

  configureFlags = [
    (lib.enableFeature nasmSupport "nasm")
    (lib.enableFeature cpmlSupport "cpml")
    #(enableFeature efenceSupport "efence")
    (if sndfileFileIOSupport then "--with-fileio=sndfile" else "--with-fileio=lame")
    (lib.enableFeature analyzerHooksSupport "analyzer-hooks")
    (lib.enableFeature decoderSupport "decoder")
    (lib.enableFeature frontendSupport "frontend")
    (lib.enableFeature frontendSupport "dynamic-frontends")
    #(enableFeature mp3xSupport "mp3x")
    (lib.enableFeature mp3rtpSupport "mp3rtp")
    (lib.optionalString debugSupport "--enable-debug=alot")
  ];

  meta = {
    description = "High quality MPEG Audio Layer III (MP3) encoder";
    homepage = "https://lame.sourceforge.io";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "lame";
  };
})
