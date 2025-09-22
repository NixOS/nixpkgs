{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6Packages,
}:
stdenv.mkDerivation rec {
  pname = "openfortivpn-webview-qt";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = "openfortivpn-webview";
    rev = "v${version}-electron";
    hash = "sha256-jGDCFdqRfnYwUgVs3KO1pDr52JgkYVRHi2KvABaZFl4=";
  };
  sourceRoot = "${src.name}/openfortivpn-webview-qt";

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

  meta = with lib; {
    description = "Perform the SAML single sign-on and easily retrieve the SVPNCOOKIE needed by openfortivpn";
    homepage = "https://github.com/gm-vm/openfortivpn-webview/tree/main";
    license = licenses.mit;
    maintainers = [ lib.maintainers.jonboh ];
    platforms = platforms.linux;
    mainProgram = "openfortivpn-webview";
  };
}
