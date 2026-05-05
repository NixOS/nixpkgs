{
  lib,
  ffmpeg_6,
  fetchgit,
}:

(ffmpeg_6.override {
  version = "6.0";
  hash = "sha256-RVbgsafIbeUUNXmUbDQ03ZN42oaUo0njqROo7KOQgv0=";

  withHardcodedTables = false;

  withHtmlDoc = false;
  withManPages = false;
  withPodDoc = false;
  withTxtDoc = false;
  withDocumentation = false;
}).overrideAttrs
  (old: {
    patches =
      (lib.filter (p: !(lib.hasSuffix "texinfo-7.1.patch" (baseNameOf (toString p)))) old.patches)
      ++ lib.filesystem.listFilesRecursive ./ffmpeg-patches;

    doCheck = false;
  })
