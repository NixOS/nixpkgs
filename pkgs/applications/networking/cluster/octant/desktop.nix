{ lib, stdenv, appimageTools, fetchurl, gsettings-desktop-schemas, gtk3, undmg }:

let
  pname = "octant-desktop";
  version = "0.19.0";
  name = "${pname}-${version}";

  inherit (stdenv.hostPlatform) system;

  suffix = {
    x86_64-linux = "AppImage";
    x86_64-darwin = "dmg";
  }.${system} or (throw "Unsupported system: ${system}");

  src = fetchurl {
    url = "https://github.com/vmware-tanzu/octant/releases/download/v${version}/Octant-${version}.${suffix}";
    sha256 = {
      x86_64-linux = "sha256-1XFb0zuyOy8XEUd9hoexItjq4assuWlWIzqw7pZxHx0=";
      x86_64-darwin = "sha256-e3v5BFX7wnx4sAQrOq+dBIDVPJYzQZKKvKjSX+dis2U=";
    }.${system};
  };

  linux = appimageTools.wrapType2 {
    inherit name src passthru meta;

    profile = ''
      export LC_ALL=C.UTF-8
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

    multiPkgs = null; # no 32bit needed
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
    extraInstallCommands =
      let appimageContents = appimageTools.extractType2 { inherit name src; }; in
      ''
        mv $out/bin/{${name},${pname}}
        install -Dm444 ${appimageContents}/octant.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/octant.desktop \
          --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
        install -m 444 -D ${appimageContents}/octant.png \
          $out/share/icons/hicolor/512x512/apps/octant.png
      '';
  };

  darwin = stdenv.mkDerivation {
    inherit name src passthru meta;

    nativeBuildInputs = [ undmg ];
    sourceRoot = "Octant.app";
    installPhase = ''
      mkdir -p $out/Applications/Octant.app
      cp -R . $out/Applications/Octant.app
    '';
  };

  passthru = { updateScript = ./update-desktop.sh; };

  meta = with lib; {
    homepage = "https://octant.dev/";
    changelog = "https://github.com/vmware-tanzu/octant/blob/v${version}/CHANGELOG.md";
    description = "Highly extensible platform for developers to better understand the complexity of Kubernetes clusters";
    longDescription = ''
      Octant is a tool for developers to understand how applications run on a
      Kubernetes cluster.
      It aims to be part of the developer's toolkit for gaining insight and
      approaching complexity found in Kubernetes. Octant offers a combination of
      introspective tooling, cluster navigation, and object management along
      with a plugin system to further extend its capabilities.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

in
if stdenv.isDarwin
then darwin
else linux
