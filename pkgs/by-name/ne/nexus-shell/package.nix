{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nexus-shell";
  version = "1.6.9";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/viewer12/Nexus-Shell-Releases/releases/download/v${finalAttrs.version}/Nexus-Shell-v${finalAttrs.version}.dmg";
    hash = "sha256-CIk465AXYKMSO+fI3xikHUgPI0NYo6VvJI3oi8yDph0=";
  };

  # The image uses APFS. Avoid extracting macOS extended attributes as files,
  # since that would corrupt the signed application bundle.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Nexus Shell.app" "$out/Applications/"

    runHook postInstall
  '';

  # Preserve the notarized signatures of the bundled binaries and resources.
  dontFixup = true;

  meta = {
    description = "Native macOS SSH workspace for terminal, SFTP, Docker, and server monitoring";
    homepage = "https://nexusshell.app/";
    changelog = "https://github.com/viewer12/Nexus-Shell-Releases/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ viewer12 ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
