{ lib, fetchurl, appimageTools, makeWrapper, nss_latest, stdenv }:
let
  common = import ./common.nix { inherit fetchurl; };

  inherit (stdenv.hostPlatform) system;

  inherit (common) pname version;
  src = common.sources.${stdenv.hostPlatform.system} or (throw "Source for ${pname} is not available for ${system}");
  name = "${pname}-${version}";

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands =
    ''
      mv $out/bin/${name} $out/bin/${pname}
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
         $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  extraPkgs = _: [ nss_latest ];

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.lens;
    maintainers = with maintainers; [ dbirks RossComputerGuy ];
    platforms = [ "x86_64-linux" ];
  };
}
