{
  alsa-lib,
  autoPatchelfHook,
  cups,
  dpkg,
  fetchurl,
  gtk3,
  lib,
  libgbm,
  libsecret,
  makeBinaryWrapper,
  musl,
  nss,
  stdenvNoCC,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "critiq";
  version = "1.12.6";

  src = fetchurl (
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")
  );

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ (
    if stdenvNoCC.hostPlatform.isLinux then
      [
        autoPatchelfHook
        dpkg
      ]
    else
      [ undmg ]
  );

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    alsa-lib
    cups
    gtk3
    libgbm
    libsecret
    musl
    nss
  ];

  sourceRoot = lib.optionalString stdenvNoCC.hostPlatform.isDarwin "Critiq.app";

  unpackPhase = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    runHook preUnpack

    dpkg-deb --extract $src $out

    runHook postUnpack
  '';

  postInstall = ''
    mkdir --parents $out/bin
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    mv $out/usr/share $out
    rmdir $out/usr
    makeWrapper $out/opt/Critiq/critiq $out/bin/critiq \
      --prefix PATH : $PATH
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p "$out"/Applications
    cp -r . "$out"/Applications/Critiq.app
    makeWrapper "$out"/Applications/Critiq.app/Contents/MacOS/Critiq "$out"/bin/critiq
  '';

  passthru.sources =
    let
      baseUrl = "https://downloads.getcritiq.dev/releases/v${finalAttrs.version}";
    in
    {
      aarch64-darwin = {
        url = "${baseUrl}/Critiq_${finalAttrs.version}_arm64.dmg";
        hash = "sha256-CGAWKui/Rq09suX+ykHdawJJD9/106FF4JThuwiLRnk=";
      };
      x86_64-linux = {
        url = "${baseUrl}/Critiq.deb";
        hash = "sha256-5WC1EikwXAg9G2+pDJsq7JzEUWFPc+kaht0fBSjmhq0=";
      };
    };

  meta = {
    description = "Native Git client for code review";
    longDescription = ''
      Compare branches, review PRs with inline comments, trace history
      with blame, full language support and symbol indexing all in one
      native workspace.
    '';
    homepage = "https://getcritiq.dev";
    license = lib.licenses.unfree;
    mainProgram = "critiq";
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
