{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,

  carto,
  gdal,
  hanazono,
  nixosTests,
  noto-fonts,
  python3,
  runCommand,
  symlinkJoin,
}:

let
  generate_env = python3.withPackages (
    p: with p; [
      colormath
      lxml
      pyyaml
    ]
  );
  get-external-data_env = python3.withPackages (
    p: with p; [
      psycopg2
      pyyaml
      requests
    ]
  );

  mkArchive =
    {
      url,
      archive_time,
      hash,
    }:
    {
      inherit url;
      archive = fetchurl {
        url = "https://web.archive.org/web/${archive_time}/${url}";
        inherit hash;
      };
    };
  simplified_water_polygons = mkArchive {
    url = "https://osmdata.openstreetmap.de/download/simplified-water-polygons-split-3857.zip";
    archive_time = "20241201150706";
    hash = "sha256-vVVbHBCbeaTaYAZRvIEQ5N1Dy5E+RaOSgZS3Uf59QkU=";
  };
  water_polygons = mkArchive {
    url = "https://osmdata.openstreetmap.de/download/water-polygons-split-3857.zip";
    archive_time = "20241201150707";
    hash = "sha256-YV3KCcVGZoSrZVjASUCPEcTCn0C39l0pG4gBl5AJm5M=";
  };
  icesheet_polygons = mkArchive {
    url = "https://osmdata.openstreetmap.de/download/antarctica-icesheet-polygons-3857.zip";
    archive_time = "20241201150705";
    hash = "sha256-QvaegTQuiju8B8IyT6qq3QDjBWk2D02bu6g07G8VPMA=";
  };
  icesheet_outlines = mkArchive {
    url = "https://osmdata.openstreetmap.de/download/antarctica-icesheet-outlines-3857.zip";
    archive_time = "20241201150707";
    hash = "sha256-d09olTATtgLO4VOAAnbO6XOrSm89DOLbSzP4id7njtU=";
  };
  ne_110m_admin_0_boundary_lines_land = mkArchive {
    url = "https://naturalearth.s3.amazonaws.com/110m_cultural/ne_110m_admin_0_boundary_lines_land.zip";
    archive_time = "20241201150708";
    hash = "sha256-uylUmBVwSYpLQ0T46D+lTKpYWOFegACUESQH0r0vlA0=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openstreetmap-carto";
  version = "5.9.0-unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "gravitystorm";
    repo = "openstreetmap-carto";
    rev = "5791e79934164f8d5ff73460ad993f3d9f64222c";
    hash = "sha256-0kPgX09oJprnTDnXdLhse8VWz/crjN5d40yKS0WhsHc=";
  };

  postPatch = ''
    substituteInPlace external-data.yml \
      --replace-fail           '${simplified_water_polygons.url}' 'file://${simplified_water_polygons.archive}' \
      --replace-fail                      '${water_polygons.url}' 'file://${water_polygons.archive}' \
      --replace-fail                   '${icesheet_polygons.url}' 'file://${icesheet_polygons.archive}' \
      --replace-fail                   '${icesheet_outlines.url}' 'file://${icesheet_outlines.archive}' \
      --replace-fail '${ne_110m_admin_0_boundary_lines_land.url}' 'file://${ne_110m_admin_0_boundary_lines_land.archive}'

    if grep http external-data.yml; then
      echo 'Not all URLs were patched!'
      exit 1
    fi

    substituteInPlace style/fonts.mss --replace-fail \
      "url('fonts')" \
      "url('${finalAttrs.passthru.fonts}')"

    substituteInPlace scripts/get-external-data.py \
      --replace-fail \
        'ogrcommand = ["ogr2ogr",' \
        'ogrcommand = ["${lib.getExe' gdal "ogr2ogr"}",' \
      --replace-fail \
        '#!/usr/bin/env python3' \
        '#!${lib.getExe get-external-data_env}'

    substituteInPlace scripts/generate_road_colours.py scripts/generate_shields.py scripts/generate_unpaved_patterns.py scripts/indexes.py \
      --replace-fail \
        '#!/usr/bin/env python3' \
        '#!${lib.getExe generate_env}'
  '';

  outputs = [
    "out"
    "get_external_data"
  ];

  buildPhase = ''
    runHook preBuild

    # Generate some files ourselves instead of relying on the pre-generated ones
    mv symbols/unpaved/unpaved.svg unpaved.svg
    mv style/road-colors-generated.mss road-colors-generated.orig.mss
    rm -r indexes.sql symbols/shields symbols/unpaved
    mkdir -p symbols/shields symbols/unpaved
    mv unpaved.svg symbols/unpaved/unpaved.svg

    scripts/indexes.py > indexes.sql
    scripts/generate_road_colours.py > style/road-colors-generated.mss
    scripts/generate_shields.py
    scripts/generate_unpaved_patterns.py

    # We don't copy this file to the output, so we can only check it here
    if ! diff 'road-colors-generated.orig.mss' 'style/road-colors-generated.mss'; then
      echo 'The file style/road-colors-generated.mss we generated differs from the pre-generated one!'
      exit 1
    fi

    mkdir -p "$out/"
    '${lib.getExe carto}' project.mml > "$out/mapnik.xml"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$get_external_data/"
    cp -r patterns/ symbols/ *.sql *.lua "$out/"
    cp external-data.yml "$get_external_data/"
    install -D scripts/get-external-data.py --target-directory="$get_external_data/bin/"
    # There should be no need for the get-fonts.sh script as we patch `style/fonts.mss` to depend directly on the fonts.

    runHook postInstall
  '';

  strictDeps = true;

  passthru = {
    fonts = symlinkJoin {
      name = "osm-fonts";
      paths = [
        # Some fonts are probably missing, please add
        "${noto-fonts}/share/fonts/noto"
        "${hanazono}/share/fonts/truetype"
      ];
    };

    tests = {
      inherit (nixosTests) nik4;
      inherit (finalAttrs.finalPackage.passthru) fonts;

      # Check that we generated the exact same files as the pre-generated ones
      compare-generated-files = runCommand "compare-generated-files" { } ''
        if ! diff '${finalAttrs.src}/indexes.sql' '${finalAttrs.finalPackage}/indexes.sql'; then
          echo 'The file indexes.sql we generated differs from the pre-generated one!'
          exit 1
        fi
        if ! diff -r '${finalAttrs.src}/symbols/shields/' '${finalAttrs.finalPackage}/symbols/shields/'; then
          echo 'The directory symbols/shields/ we generated differs from the pre-generated one!'
          exit 1
        fi
        if ! diff -r --exclude=unpaved.md '${finalAttrs.src}/symbols/unpaved/' '${finalAttrs.finalPackage}/symbols/unpaved/'; then
          echo 'The directory symbols/unpaved/ we generated differs from the pre-generated one!'
          exit 1
        fi

        touch "$out"
      '';
    };
  };

  meta = {
    description = "General-purpose OpenStreetMap mapnik style, in CartoCSS";
    homepage = "https://github.com/gravitystorm/openstreetmap-carto";
    license = lib.licenses.cc0;
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ Luflosi ]);
    platforms = lib.platforms.linux;
  };
})
