{
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeWrapper,
  pname,
  updateScript,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = "6.14.0";

  src = fetchurl {
    url = "https://github.com/ProxymanApp/Proxyman/releases/download/${finalAttrs.version}/Proxyman_${finalAttrs.version}.dmg";
    hash = "sha256-bdIitfbr5Pr0glJcVDMfE/1ehpbRy5/pwXmUz0ivuvo=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Proxyman.app $out/Applications
    makeWrapper $out/Applications/Proxyman.app/Contents/MacOS/Proxyman $out/bin/proxyman

    runHook postInstall
  '';

  dontFixup = true;

  passthru = {
    inherit updateScript;
  };

  meta = meta // {
    changelog = "https://proxyman.com/changelog";
    platforms = [ "aarch64-darwin" ];
  };
})
