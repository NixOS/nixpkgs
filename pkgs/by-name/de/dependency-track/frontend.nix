{
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  dependency-track,
}:

buildNpmPackage (finalAttrs: {
  pname = dependency-track.pname + "-frontend";
  inherit (dependency-track) version;

  src = fetchFromGitHub {
    owner = "DependencyTrack";
    repo = "frontend";
    tag = finalAttrs.version;
    hash = "sha256-9yIgRLekZXDCu/Gttm+VdumuyQQMZO2/RVwRyDnEkxk=";
  };

  npmDepsHash = "sha256-LmYPM0qWgbZcH1AHNJsHaPftyzneb3j09tHisYXFLjc=";
  forceGitDeps = true;
  makeCacheWritable = true;

  nativeBuildInputs = [ jq ];

  # Pin the embedded build timestamp and derive the build UUID from $out.
  postPatch = ''
    substituteInPlace update-embedded-version.js \
      --replace-fail 'uuidv4()' "'$(sha256sum <<< "$out" | sed -E 's/^(.{8})(.{4})(.{4})(.{4})(.{12}).*/\1-\2-\3-\4-\5/')'" \
      --replace-fail 'new Date().toISOString()' "'$(date -ud "@$SOURCE_DATE_EPOCH" +%FT%T.000Z)'"
  '';

  # @cyclonedx/webpack-plugin adds the current time and a random serial number,
  # and builds a different dependency graph on each run.
  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq 'del(.serialNumber, .metadata.timestamp, .dependencies)' dist/.well-known/sbom > $out/.well-known/sbom

    runHook postInstall
  '';

  meta = (removeAttrs dependency-track.meta [ "mainProgram" ]) // {
    description = dependency-track.meta.description + " - frontend";
    homepage = "https://github.com/DependencyTrack/frontend";
  };
})
