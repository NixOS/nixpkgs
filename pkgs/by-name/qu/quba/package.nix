{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  _7zz,
  writeShellScript,
  nix-update,
  common-updater-scripts,
}:

let
  pname = "quba";
  version = "1.5.0";

  passthru.updateScript = writeShellScript "update-quiet" ''
    ${lib.getExe nix-update} --system=x86_64-linux quba
    hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw --file . quba.src.url --system aarch64-darwin)))
    ${lib.getExe' common-updater-scripts "update-source-version"} quba $(nix eval --raw --file . quba.version) $hash --system=aarch64-darwin --ignore-same-version
  '';

  meta = {
    description = "Viewer for electronic invoices";
    homepage = "https://github.com/ZUGFeRD/quba-viewer";
    downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ onny ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };

  src = fetchurl {
    url = "https://github.com/ZUGFeRD/quba-viewer/releases/download/v${version}/Quba-${version}.AppImage";
    hash = "sha256-xB1r8DNFOFQQx+MeGC1mWhf7PuMavM7DyYRBlEjAZ8k=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/quba.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/quba.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=quba'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      passthru
      meta
      ;

    src = fetchurl {
      url = "https://github.com/ZUGFeRD/quba-viewer/releases/download/v${version}/Quba-${version}-universal.dmg";
      hash = "sha256-niuU1zkxNRmCYxzto3g6i6Z3k5KCAgVIVQMgOLZJnSE=";
    };

    unpackCmd = "7zz x -bd -osource -xr'!*/Applications' -xr'!*com.apple.provenance' $curSrc";

    nativeBuildInputs = [ _7zz ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      mv Quba.app $out/Applications

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isLinux then linux else darwin
