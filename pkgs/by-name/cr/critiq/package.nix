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
  version = "1.9.1";

  src = fetchurl (
    if with stdenvNoCC.hostPlatform; (isDarwin && isAarch64) then
      {
        url = "https://downloads.getcritiq.dev/releases/v${finalAttrs.version}/Critiq_${finalAttrs.version}_arm64.dmg";
        hash = "sha256-xT4rtz7wChkGmf0m+qLq3+5YZEO9r0kWPvjgf1nF3OY=";
      }
    else if with stdenvNoCC.hostPlatform; (isDarwin && isx86_64) then
      {
        url = "https://downloads.getcritiq.dev/releases/v${finalAttrs.version}/Critiq_${finalAttrs.version}_x64.dmg";
        hash = "sha256-JW31az3/UcgjCcl0xoO9N+8qDtax57x9Im8U3NBjDlw=";
      }
    else if with stdenvNoCC.hostPlatform; (isLinux && isx86_64) then
      {
        url = "https://downloads.getcritiq.dev/releases/v${finalAttrs.version}/Critiq.deb";
        hash = "sha256-wmJN3RDngcimy//365z0iCd0K8TSYzM3VHAanCwvtmg=";
      }
    else
      throw "Unsupported platform"
  );

  strictDeps = true;

  nativeBuildInputs = (
    if stdenvNoCC.hostPlatform.isLinux then
      [
        autoPatchelfHook
        dpkg
        makeBinaryWrapper
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

  buildPhase = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    runHook preBuild

    dpkg-deb --extract $src $out

    runHook postBuild
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
    mkdir --parents "$out"/Applications
    cp --recursive . "$out"/Applications/Critiq.app
    cat >"$out"/bin/critiq <<'EOF'
    #!/usr/bin/env sh
    exec "${placeholder "out"}/Applications/Critiq.app/Contents/MacOS/Critiq" "$@"
    EOF
    chmod +x "$out"/bin/critiq
  '';

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
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
