{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openfortivpn-webview-qt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${finalAttrs.version}-qt";
    hash = "sha256-TohrOgLzvxmUsRVV36XHgE9ul38CjU/qKF+LZOZQieE=";
  };
  sourceRoot = "${finalAttrs.src.name}/openfortivpn-webview-qt";

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
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
