{ appimageTools
, makeDesktopItem
, fetchurl
, lib
, gtk3
, gsettings-desktop-schemas
}:

let
  pname = "librewolf-bin";
  version = "89.0.2-1";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://gitlab.com/librewolf-community/browser/appimage/-/jobs/1374407522/artifacts/raw/LibreWolf-${version}.x86_64.AppImage";
    sha256 = "sha256-4h1NBzKh3++JDaq4dup5mGrn973THMU0jbFPjC3dtDw=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
  appimageTools.wrapType2 {
    inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/librewolf
    '';

  meta = with lib; {
    description = "A fork of Firefox, focused on privacy, security and freedom.";
    homepage = "https://librewolf-community.gitlab.io/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
