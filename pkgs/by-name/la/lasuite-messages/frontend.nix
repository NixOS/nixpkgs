{
  src,
  version,
  meta,
  fetchNpmDeps,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "lasuite-messages-frontend";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs)
      version
      src
      sourceRoot
      ;
    fetcherVersion = 2;

    hash = "sha256-C1dIeWDMdkFWZfSq+zl0CVIxrrD5C8klrDoYSnI6BK4=";
  };

  npmDepsFetcherVersion = 2;
  npmBuildScript = "build";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"node": "24.18.0"' '"node": "^24.18.0"'
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/ $out

    runHook postInstall
  '';

  meta = meta // {
    description = "Messages is a full communication platform enabling teams to collaborate on emails through shared or personal mailboxes";
  };
})
