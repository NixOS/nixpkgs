{
  lib,
  appimageTools,
  fetchurl,
  libgdiplus,
}:
let
  pname = "smath-studio";
  version = "1.5.0.9678";

  src = fetchurl {
    # The code after /Download/ changes per release
    url = "https://smath.com/en-US/files/Download/c4zCE/SMathStudioDesktop.1_5_0_9678.x86_64.ubuntu-22_04.glibc2.35.AppImage";
    hash = "sha256-6lnuRnhoH6E+jIZXSgb/Pz9wE9nVAbduDHrkKCKKH+Y=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      gtk2
    ];

  profile = ''
    export LD_PRELOAD="${libgdiplus}/lib/libgdiplus.so.0"
  '';

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/*.desktop -t $out/share/applications
    sed -i "s|^Exec=.*|Exec=smath-studio %U|" $out/share/applications/*.desktop

    # Package icons into /apps directory
    for icon in ${appimageContents}/usr/share/icons/hicolor/*/*.png; do
      if [ -f "$icon" ]; then
        size=$(basename $(dirname "$icon"))
        install -m 444 -D "$icon" "$out/share/icons/hicolor/$size/apps/smath.png"
      fi
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Tiny, powerful, free mathematical program with WYSIWYG editor and complete units of measurements support";
    homepage = "https://smath.com/";
    license = licenses.unfree; # SMath is freeware, but closed source
    maintainers = with maintainers; [ frajul ];
    mainProgram = "smath-studio";
    platforms = [ "x86_64-linux" ];
  };
}
