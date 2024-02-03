{ lib
, stdenvNoCC
, rustPlatform
, fetchFromGitHub
, buildGoModule
, makeWrapper
, nodePackages
, cacert
, esbuild
, jq
, moreutils
, perl
, pkg-config
, glib
, webkitgtk
, libayatana-appindicator
, cairo
, openssl
}:

let
  version = "4.10.1";
  geph-meta = with lib; {
    description = "A modular Internet censorship circumvention system designed specifically to deal with national filtering.";
    homepage = "https://geph.io";
    platforms = platforms.linux;
    maintainers = with maintainers; [ penalty1083 ];
  };
in
{
  cli = rustPlatform.buildRustPackage rec {
    pname = "geph4-client";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-e0Pdg4pQ5s1wvTnFm1rKuAwkYtCtu2Uacd7yH3EHeCo=";
    };

    cargoHash = "sha256-Kwc+EOH2pJJVvIcTUfL39Xrv/7YmTPUDge7mmjDs9pQ=";

    nativeBuildInputs = [ perl ];

    meta = geph-meta // {
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  gui = stdenvNoCC.mkDerivation rec {
    pname = "geph-gui";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = "gephgui-pkg";
      rev = "4163e12188dd679ba548e127fc9771cb5e87bab0";
      hash = "sha256-wBvhfgp5sZTRCBR9HZqs1G0VaIt9DW2e9CWMAp/T5WI=";
      fetchSubmodules = true;
    };

    pnpm-deps = stdenvNoCC.mkDerivation {
      pname = "${pname}-pnpm-deps";
      inherit src version;

      sourceRoot = "source/gephgui-wry/gephgui";

      nativeBuildInputs = [
        jq
        moreutils
        nodePackages.pnpm
        cacert
      ];

      installPhase = ''
        export HOME=$(mktemp -d)
        pnpm config set store-dir $out
        pnpm install --ignore-scripts

        # Remove timestamp and sort the json files
        rm -rf $out/v3/tmp
        for f in $(find $out -name "*.json"); do
          sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
          jq --sort-keys . $f | sponge $f
        done
      '';

      dontFixup = true;
      outputHashMode = "recursive";
      outputHash = "sha256-OKPx5xRI7DWd6m31nYx1biP0k6pcZ7fq7dfVlHda4O0=";
    };

    gephgui-wry = rustPlatform.buildRustPackage {
      pname = "gephgui-wry";
      inherit version src;

      sourceRoot = "source/gephgui-wry";

      cargoLock = {
        lockFile = ./Cargo.lock;
        outputHashes = {
          "tao-0.5.2" = "sha256-HyQyPRoAHUcgtYgaAW7uqrwEMQ45V+xVSxmlAZJfhv0=";
          "wry-0.12.2" = "sha256-kTMXvignEF3FlzL0iSlF6zn1YTOCpyRUDN8EHpUS+yI=";
        };
      };

      nativeBuildInputs = [
        pkg-config
        nodePackages.pnpm
        makeWrapper
      ];

      buildInputs = [
        glib
        webkitgtk
        libayatana-appindicator
        cairo
        openssl
      ];

      ESBUILD_BINARY_PATH = "${lib.getExe (esbuild.override {
        buildGoModule = args: buildGoModule (args // rec {
          version = "0.15.10";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-DebmLtgPrla+1UcvOHMnWmxa/ZqrugeRRKXIiJ9LYDk=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        });
      })}";

      preBuild = ''
        cd gephgui
        export HOME=$(mktemp -d)
        pnpm config set store-dir ${pnpm-deps}
        pnpm install --ignore-scripts --offline
        chmod -R +w node_modules
        pnpm rebuild
        pnpm build
        cd ..
      '';
    };

    dontBuild = true;

    installPhase = ''
      install -Dt $out/bin ${gephgui-wry}/bin/gephgui-wry
      install -d $out/share/icons/hicolor
      for i in '16' '32' '64' '128' '256'
      do
        name=''${i}x''${i}
        dir=$out/share/icons/hicolor
        mkdir -p $dir
        mv flatpak/icons/$name $dir
      done
      install -Dt $out/share/applications flatpak/icons/io.geph.GephGui.desktop
      sed -i -e '/StartupWMClass/s/=.*/=gephgui-wry/' $out/share/applications/io.geph.GephGui.desktop
    '';

    meta = geph-meta // {
      license = with lib.licenses; [ unfree ];
    };
  };
}
