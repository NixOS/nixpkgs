{ buildNpmPackage
, src
, version
}:

buildNpmPackage {
  pname = "frigate-web";
  inherit version src;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "--base=/BASE_PATH/" ""

    substituteInPlace \
      src/views/system/StorageMetrics.tsx \
      src/components/card/{AnimatedEvent,Export,Review}Card.tsx \
      src/components/timeline/EventSegment.tsx \
      src/pages/Exports.tsx \
      src/components/player/PreviewThumbnailPlayer.tsx \
      --replace-fail "/media/frigate" "/var/lib/frigate" \

    substituteInPlace src/views/system/StorageMetrics.tsx \
      --replace-fail "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-PLs3oCWQjK38eHgdQt2Qkj7YqkfanC8JnLMpzMjNfxU=";

  installPhase = ''
    cp -rv dist/ $out
  '';
}
