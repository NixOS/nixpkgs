{
  fetchurl,
  appimageTools,
  lib,
  makeWrapper,
}:

let
  pname          = "buckets";
  version        = "0.71.1";
  name           = "Buckets-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url    = "https://github.com/buckets/application/releases/download/v${version}/${name}.AppImage";
    name   = "${name}.AppImage";
    sha256 = "16cjb4xbxgxjj4ci560ygd9y295wvckh1dfhvk1kpisg2dz94krq";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libsodium ];
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    for size in 16 32 48 64 128 256 512; do
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done
  '';

  meta = with lib; {
    description = "Private family budgeting app";
    homepage    = "https://www.budgetwithbuckets.com/";
    license     = licenses.unfree;
    maintainers = with maintainers; [ kmogged ];
    platforms = [ "x86_64-linux" ];
  };
}

