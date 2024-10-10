{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:
buildNpmPackage rec {
  pname = "openfortivpn-webview";
  version = "1.2.0-electron";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HheqDjlWxHJS0+OEhRTwANs9dyz3lhhCmWh+YH4itOk=";
  };
  sourceRoot = "${src.name}/openfortivpn-webview-electron";

  npmDepsHash = "sha256-Vf8R0+RXHlXwPOnPENw8ooxIXT3kSppQmB2yk5TWEwg=";

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  dontNpmBuild = true;

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/openfortivpn-webview \
        --add-flags $out/lib/node_modules/openfortivpn-webview/index.js
  '';

  meta = with lib; {
    description = " Command-line tool to perform SAML single sign-on and retrieve the SVPNCOOKIE needed by openfortivpn.";
    homepage = "https://github.com/gm-vm/openfortivpn-webview";
    license = licenses.mit;
    mainProgram = "openfortivpn-webview";
    maintainers = with maintainers; [ emilioziniades ];
  };
}
