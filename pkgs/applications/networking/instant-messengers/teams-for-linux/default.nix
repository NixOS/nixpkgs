{ lib, fetchurl, appimageTools, libdrm, pipewire }:

let
  pname = "teams-for-linux";
  version = "1.0.45";

  src = fetchurl {
    url = "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${version}/teams-for-linux-${version}.AppImage";
    sha256 = "sha256-aZFKczf+ZHMRHkk++BQ8WlsYGtrM8AuJ8Y3sU5rgYHs=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ with pkgs; [ libdrm pipewire ];

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -m 444 \
        -D ${appimageContents}/teams-for-linux.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/teams-for-linux.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "An unofficial Microsoft Teams client";
    homepage = "https://github.com/IsmaelMartinez/teams-for-linux";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
  };
}
