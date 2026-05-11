{
  lib,
  imagemagick,
  ...
}@args:

lib.lowPrio (
  imagemagick.override (
    {
      bzip2Support = false;
      zlibSupport = false;
      libX11Support = false;
      libXtSupport = false;
      fontconfigSupport = false;
      freetypeSupport = false;
      libraqmSupport = false;
      libjpegSupport = false;
      djvulibreSupport = false;
      lcms2Support = false;
      openexrSupport = false;
      libjxlSupport = false;
      libpngSupport = false;
      liblqr1Support = false;
      librsvgSupport = false;
      libtiffSupport = false;
      libxml2Support = false;
      openjpegSupport = false;
      libwebpSupport = false;
      libheifSupport = false;
    }
    // removeAttrs args [
      "imagemagick"
      "lib"
    ]
  )
)
