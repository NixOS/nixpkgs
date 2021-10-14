{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3, stdenv, undmg }:

let
  pname = "marktext";
  version = "v0.16.3";
  name = "${pname}-${version}-binary";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/marktext/marktext/releases/download/${version}/marktext-x86_64.AppImage";
      sha256 = "0s93c79vy2vsi7b6xq4hvsvjjad8bdkhl1q135vp98zmbf7bvm9b";
    };

    x86_64-darwin = fetchurl {
      url = "https://github.com/marktext/marktext/releases/download/${version}/marktext.dmg";
      sha256 = "sha256-cFTlakOdXQndSwiY4B5UHhr7Ivx0VWZ4vLAG03weBB0=";
    };

    aarch64-darwin = srcs.x86_64-darwin;
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;

    appimageContents = appimageTools.extractType2 {
      inherit name src;
    };

    profile = ''
      export LC_ALL=C.UTF-8
    ''
    # Fixes file open dialog error
    #     GLib-GIO-ERROR **: 20:36:48.243: No GSettings schemas are installed on the system
    # See https://github.com/NixOS/nixpkgs/pull/83701#issuecomment-608034097
    + ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

    multiPkgs = null; # no 32bit needed
    extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
      p.libsecret
      p.xorg.libxkbfile
    ];

    # Strip version from binary name.
    extraInstallCommands = ''
      # Strip version from binary name.
      mv $out/bin/${name} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/marktext.desktop $out/share/applications/marktext.desktop
      substituteInPlace $out/share/applications/marktext.desktop \
        --replace "Exec=AppRun" "Exec=${pname} --"

      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  };

  darwin = stdenv.mkDerivation {
    inherit pname src meta version;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Mark Text.app";

    installPhase = ''
      mkdir -p "$out/Applications/Mark Text.app"
      cp -R . "$out/Applications/Mark Text.app"
    '';
  };

  meta = with lib; {
    description = "A simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://marktext.app";
    license = licenses.mit;
    maintainers = with maintainers; [ nh2 arkivm ];
    platforms = builtins.attrNames srcs;
  };
in
if stdenv.isDarwin
then darwin
else linux
