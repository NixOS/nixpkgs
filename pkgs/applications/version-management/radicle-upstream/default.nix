{ lib, stdenv, appimageTools, autoPatchelfHook, zlib, fetchurl, undmg }:

let
  pname = "radicle-upstream";
  version = "0.3.0";
  name = "${pname}-${version}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://releases.radicle.xyz/radicle-upstream-${version}.AppImage";
      sha256 = "sha256-Y7V89G+nXRtknOukvBN8Q+sNx91YNPDT0p5hrFYe/Sk=";
    };
    x86_64-darwin = fetchurl {
      url = "https://releases.radicle.xyz/radicle-upstream-${version}.dmg";
      sha256 = "sha256-EuWGbn6qggi8/9Rci8iaXfuVKE+QXb1BHEYDvotR/q4=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};

  contents = appimageTools.extract { inherit name src; };

  git-remote-rad = stdenv.mkDerivation rec {
    pname = "git-remote-rad";
    inherit version;
    src = contents;

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ zlib ];

    installPhase = ''
      mkdir -p $out/bin/
      cp ${contents}/resources/git-remote-rad $out/bin/git-remote-rad
    '';
  };

  # FIXME: a dependency of the `proxy` component of radicle-upstream (radicle-macros
  # v0.1.0) uses unstable rust features, making a from source build impossible at
  # this time. See this PR for discussion: https://github.com/NixOS/nixpkgs/pull/105674
  linux = appimageTools.wrapType2 {
    inherit name src meta;

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}

      # this automatically adds the git-remote-rad binary to the users `PATH` so
      # they don't need to mess around with shell profiles...
      ln -s ${git-remote-rad}/bin/git-remote-rad $out/bin/git-remote-rad

      # desktop item
      install -m 444 -D ${contents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      # icon
      install -m 444 -D ${contents}/${pname}.png \
        $out/share/icons/hicolor/512x512/apps/${pname}.png
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };

  meta = with lib; {
    description = "A decentralized app for code collaboration";
    homepage = "https://radicle.xyz/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d-xo ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    broken = stdenv.isLinux; # last successful build 2023-04-11
  };
in
if stdenv.isDarwin
then darwin
else linux
