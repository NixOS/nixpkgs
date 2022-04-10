{ lib
, fetchurl
, appimageTools
, libsecret
, gtk3
, gsettings-desktop-schemas
}:

let
  version = "4.7.1";
  pname = "timeular";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular-${version}.AppImage";
    sha256 = "sha256:0k8ywbdb41imq10ya9y27zks67a6drjb1h0hn8ycd7a6z6703rjz";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/timeular.desktop $out/share/applications/timeular.desktop
    install -m 444 -D ${appimageContents}/timeular.png $out/share/icons/hicolor/512x512/apps/timeular.png
    substituteInPlace $out/share/applications/timeular.desktop \
      --replace "Exec=AppRun --no-sandbox %U" "Exec=$out/bin/${pname}"
  '';

  meta = with lib; {
    description = "Timetracking by flipping 8-sided dice";
    longDescription = ''
      The Timeular Tracker is an 8-sided dice that sits on your desk.
      Assign an activity to each side and flip to start tracking your time.
      The desktop app tell you where every minute of your day is spent.
    '';
    homepage = "https://timeular.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ ktor ];
    platforms = [ "x86_64-linux" ];
  };
}
