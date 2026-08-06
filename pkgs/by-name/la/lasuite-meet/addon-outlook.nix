{
  src,
  version,
  meta,
  fetchNpmDeps,
  buildNpmPackage,
  pkg-config,
  libsecret,
}:
buildNpmPackage (finalAttrs: {
  pname = "lasuite-meet-addon-outlook";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/addons/outlook";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsecret
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) version src sourceRoot;
    hash = "sha256-1xsvOHTIO1dxNlb+lISr0Qtt7/QScLS1AUXzpZWTIuc=";
  };
  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    cp manifest.xml $out

    runHook postInstall
  '';

  meta = meta // {
    description = "Microsoft Outlook add-in support for LaSuite Meet";
  };
})
