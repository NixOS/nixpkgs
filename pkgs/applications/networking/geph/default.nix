{ lib
, stdenv
, pkgs
, rustPlatform
, fetchFromGitHub
, nodejs-14_x
, pkg-config
, glib
, webkitgtk
, libappindicator-gtk3
, libayatana-appindicator-gtk3
, cairo
}:

let
  version = "4.5.0-beta.1";
  geph-meta = with lib; {
    description = "A modular Internet censorship circumvention system designed specifically to deal with national filtering.";
    homepage = "https://geph.io";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jslll135 ];
  };
in
{
  cli = rustPlatform.buildRustPackage rec {
    pname = "geph4-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = "geph4";
      rev = "v${version}";
      hash = "sha256-FtdXl+29VVJxmKvtc03PFji/ilkJ8XTymUqjPfBh5hk=";
    };

    cargoPatches = [ ./cargo.patch ];

    cargoHash = "sha256-wJE9QW9X/LDfa32pUK7oUc+w1MSd1fVodk73ZcfZhSI=";

    meta = geph-meta // {
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  gui = stdenv.mkDerivation rec {
    pname = "geph-gui";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = "gephgui-pkg";
      rev = "74c8437b6c4e04e7792ebbf74de2a8e82cf337a6";
      hash = "sha256-WhH7W9mDWRBt9SiRjtslcZZvYgTkFW9D9k7T1z7pMVo=";
      fetchSubmodules = true;
    };

    geph-vpn-helper = rustPlatform.buildRustPackage rec {
      pname = "geph4-vpn-helper";
      version = "0.2.4";

      inherit src;
      sourceRoot = "source/${pname}";

      cargoHash = "sha256-NutGGc+xXJ8CDkBXSlE0r5O19q/epmoNSUvrOXmlNKA=";
    };

    gephgui-wry = rustPlatform.buildRustPackage rec {
      pname = "gephgui-wry";
      version = "unstable-2021-11-16";

      inherit src;
      sourceRoot = "source/${pname}";

      cargoHash = "sha256-dyuJ5Re7379e4WliCzezURcYzLJRcqXvKU3Xmms0nkQ=";

      nativeBuildInputs = [
        pkg-config
        nodejs-14_x
      ];

      buildInputs = [
        glib
        webkitgtk
        libappindicator-gtk3
        libayatana-appindicator-gtk3
        cairo
      ];

      nodeDependencies = ((import ./node-composition.nix {
        inherit pkgs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = "${src}/${pname}/gephgui";
        dontNpmInstall = true;
      }));

      preBuild = ''
        cd gephgui
        ln -s ${nodeDependencies}/lib/node_modules .
        export PATH="${nodeDependencies}/bin:$PATH"
        npm run build
        cd ..
      '';
    };

    dontBuild = true;

    installPhase = ''
      install -Dt $out/bin ${geph-vpn-helper}/bin/geph4-vpn-helper
      install -Dt $out/bin ${gephgui-wry}/bin/gephgui-wry
      install -d $out/share/icons/hicolor
      for i in '16' '32' '64' '128' '256'
      do
        name=''${i}x''${i}
        dir=$out/share/icons/hicolor/$name/apps
        mkdir -p $dir
        mv flatpak/icons/$name/io.geph.GephGui.png $dir
      done
      install -Dt $out/share/applications flatpak/icons/io.geph.GephGui.desktop
    '';

    meta = geph-meta // {
      mainProgram = "gephgui-wry";
      license = with lib.licenses; [ unfree ];
    };
  };
}
