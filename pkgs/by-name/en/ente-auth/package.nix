{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "ente-auth";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/ente-io/ente/releases/download/auth-v${version}/ente-auth-v${version}-x86_64.AppImage";
    hash = "sha256-RcH+1YM6gPneVbv158LejClkrCNnAwr6K5hKbcyvTMI=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/ente_auth.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/ente_auth.desktop \
      --replace-fail 'Exec=LD_LIBRARY_PATH=usr/lib ente_auth' 'Exec=ente-auth'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = pkgs: [
    pkgs.libepoxy
    pkgs.brotli
  ];

  meta = {
    description = "An end-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups.";
    homepage = "https://ente.io/auth";
    changelog = "https://github.com/ente-io/ente/releases/tag/auth-v${version}";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ente-auth";
    maintainers = with lib.maintainers; [ schnow265 ];
  };
}
