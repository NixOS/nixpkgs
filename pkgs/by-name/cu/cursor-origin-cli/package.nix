{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

let
  inherit (stdenv) hostPlatform;
  sources = {
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/co/2026.08.18-07-32-40-5c3b379/darwin-arm64/co.tar.gz";
      hash = "sha256-hMK2v1Y0tp8V21RVk6ry9ihD+/02hiRn4gEMm5Whi8E=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/co/2026.08.18-07-32-40-5c3b379/linux-arm64/co.tar.gz";
      hash = "sha256-MCxixYhhEU381gDIjDTseP6R7yKCGGOyVRnlRONHAr4=";
    };
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/co/2026.08.18-07-32-40-5c3b379/linux-x64/co.tar.gz";
      hash = "sha256-pL5U3XFUqfkHdsh0QMHPr0Jb24Yu35GXulbVfvXMj7U=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-origin-cli";
  version = "2026.08.18-07-32-40-5c3b379";

  __structuredAttrs = true;
  strictDeps = true;

  src = sources.${hostPlatform.system};

  # The source tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir source
    cd source
  '';
  sourceRoot = ".";

  nativeBuildInputs = lib.optionals hostPlatform.isLinux [ autoPatchelfHook ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 origin $out/bin/origin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "CLI for Cursor's Origin code hosting platform";
    homepage = "https://cursor.com/docs/origin/cli";
    downloadPage = "https://downloads.cursor.com/origin/install.sh";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ omarjatoi ];
    mainProgram = "origin";
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
