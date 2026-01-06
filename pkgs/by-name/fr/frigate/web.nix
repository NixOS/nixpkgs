{
  buildNpmPackage,
  frigate,
  src,
  version,
}:

buildNpmPackage {
  pname = "frigate-web";
  inherit version src;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "--base=/BASE_PATH/" ""

    substituteInPlace \
      src/pages/Exports.tsx \
      src/components/preview/ScrubbablePreview.tsx \
      src/components/card/ExportCard.tsx \
      src/components/card/ReviewCard.tsx \
      src/components/card/AnimatedEventCard.tsx \
      src/components/player/PreviewThumbnailPlayer.tsx \
      src/views/system/StorageMetrics.tsx \
      src/components/timeline/EventSegment.tsx \
      --replace-fail "/media/frigate" "/var/lib/frigate" \

    substituteInPlace src/views/system/StorageMetrics.tsx \
      --replace-fail "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-CrK/6BaKmKIxlohEZdGEEKJkioszBUupyKQx4nBeLqI=";

  installPhase = ''
    cp -rv dist/ $out
  '';

  inherit (frigate) meta;
}
