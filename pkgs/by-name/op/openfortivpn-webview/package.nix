{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:

let
  version = "1.2.0";
in
buildNpmPackage {
  pname = "openfortivpn-webview";
  inherit version;
  src =
    (fetchFromGitHub {
      owner = "gm-vm";
      repo = "openfortivpn-webview";
      rev = "v${version}-electron";
      hash = "sha256-HheqDjlWxHJS0+OEhRTwANs9dyz3lhhCmWh+YH4itOk=";
    })
    + "/openfortivpn-webview-electron";

  installPhase = ''
    runHook preInstall
    npmInstallHook
    makeWrapper ${lib.getExe electron} $out/bin/openfortivpn-webview --add-flags $out/lib/node_modules/openfortivpn-webview
    runHook postInstall
  '';

  npmDepsHash = "sha256-Vf8R0+RXHlXwPOnPENw8ooxIXT3kSppQmB2yk5TWEwg=";
  dontNpmBuild = true;
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  meta = {
    description = "Application to perform the SAML single sing-on and easily retrieve the SVPNCOOKIE needed by openfortivpn";
    homepage = "https://github.com/gm-vm/openfortivpn-webview";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lriesebos ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "openfortivpn-webview";
  };
}
