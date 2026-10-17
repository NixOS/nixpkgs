# gerbera with all dependencies enabled
# mainly to make sure all optional dependencies work
{ gerbera }:
(gerbera.override {
  enableAvcodec = true;
  enableCurl = true;
  enableDuktape = true;
  enableExiv2 = true;
  enableFFmpegThumbnailer = true;
  enableInotifyTools = true;
  enableLibexif = true;
  enableLibmagic = true;
  enableLibmatroska = true;
  enableMysql = true;
  enablePgsql = true;
  enableTaglib = true;
  enableWavPack = true;
  enableZip = true;
}).overrideAttrs
  (prevAttrs: {
    meta = prevAttrs.meta // {
      description = prevAttrs.meta.description + " (with all optional dependencies enabled)";
    };
  })
