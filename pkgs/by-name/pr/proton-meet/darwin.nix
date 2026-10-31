{
  stdenvNoCC,
  undmg,
  pname,
  version,
  passthru,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  # The app is signed and notarized by Proton; the fixup phase would strip its
  # Mach-O files and replace the Developer ID signatures with ad-hoc ones.
  dontFixup = true;

  inherit passthru meta;
})
