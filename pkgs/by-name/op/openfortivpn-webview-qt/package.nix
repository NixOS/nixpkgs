{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openfortivpn-webview-qt";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${finalAttrs.version}-electron";
    hash = "sha256-jGDCFdqRfnYwUgVs3KO1pDr52JgkYVRHi2KvABaZFl4=";
  };
  sourceRoot = "${finalAttrs.src.name}/openfortivpn-webview-qt";

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qmake
  ];
  buildInputs = [ qt6Packages.qtwebengine ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp openfortivpn-webview $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Perform the SAML single sign-on and easily retrieve the SVPNCOOKIE needed by openfortivpn";
    homepage = "https://github.com/gm-vm/openfortivpn-webview/tree/main";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jonboh ];
    platforms = lib.platforms.linux;
    mainProgram = "openfortivpn-webview";
  };
})
