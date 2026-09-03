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
    substituteInPlace site.webmanifest \
      --replace-fail '/BASE_PATH/' '/'

    substituteInPlace \
      src/components/card/AnimatedEventCard.tsx \
      src/components/card/ExportCard.tsx \
      src/components/card/ReviewCard.tsx \
      src/components/player/PreviewThumbnailPlayer.tsx \
      src/components/preview/ScrubbablePreview.tsx \
      src/pages/Exports.tsx \
      src/views/system/StorageMetrics.tsx \
      --replace-fail "/media/frigate" "/var/lib/frigate" \

    substituteInPlace src/views/system/StorageMetrics.tsx \
      --replace-fail "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-iIqP3pspkDbaXZkZ5MIT/GVGiKBJCkFXQ7Av5h1rWKk=";

  installPhase = ''
    cp -rv dist/ $out
  '';

  inherit (frigate) meta;
}
