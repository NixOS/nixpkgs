{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  nodejs,
  pnpm,
  esbuild,
  perl,
  pkg-config,
  glib,
  webkitgtk,
  libayatana-appindicator,
  cairo,
  openssl,
}:

let
  version = "4.99.2";
  geph-meta = with lib; {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
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
      hash = "sha256-aZFm4+oUQungCPbxs7j1J8hLcCYoIodIEQEiQfjoLUw=";
    };

    cargoHash = "sha256-ypnjVoscGqVifkjzFh2KE+3EVFWIiyahTNTil3nu/+s=";

    nativeBuildInputs = [ perl ];

    meta = geph-meta // {
      license = with lib.licenses; [ gpl3Only ];
    };
  };

  gui = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "geph-gui";
    inherit version;

    src = fetchFromGitHub {
      owner = "geph-official";
      repo = "gephgui-pkg";
      rev = "3b045e21b8c587c26f9d5f0f2b4bdf0a34bfee80";
      hash = "sha256-p+AxAOznUsG45Ibm1kczapfmbK+aeex2js463eqZ8gY=";
      fetchSubmodules = true;
    };

    gephgui-wry = rustPlatform.buildRustPackage {
      pname = "gephgui-wry";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/gephgui-wry";

      cargoLock = {
        lockFile = ./Cargo.lock;
        outputHashes = {
          "tao-0.5.2" = "sha256-HyQyPRoAHUcgtYgaAW7uqrwEMQ45V+xVSxmlAZJfhv0=";
          "wry-0.12.2" = "sha256-kTMXvignEF3FlzL0iSlF6zn1YTOCpyRUDN8EHpUS+yI=";
        };
      };

      pnpmDeps = pnpm.fetchDeps {
        inherit (finalAttrs) pname version src;
        sourceRoot = "${finalAttrs.src.name}/gephgui-wry/gephgui";
        hash = "sha256-0MGlsLEgugQ1wEz07ROIwkanTa8PSKwIaxNahyS1014=";
      };

      nativeBuildInputs = [
        pkg-config
        pnpm.configHook
        makeWrapper
        nodejs
      ];

      buildInputs = [
        glib
        webkitgtk
        libayatana-appindicator
        cairo
        openssl
      ];

      ESBUILD_BINARY_PATH = "${lib.getExe (
        esbuild.override {
          buildGoModule =
            args:
            buildGoModule (
              args
              // rec {
                version = "0.15.10";
                src = fetchFromGitHub {
                  owner = "evanw";
                  repo = "esbuild";
                  rev = "v${version}";
                  hash = "sha256-DebmLtgPrla+1UcvOHMnWmxa/ZqrugeRRKXIiJ9LYDk=";
                };
                vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
              }
            );
        }
      )}";

      pnpmRoot = "gephgui";

      preBuild = ''
        pushd gephgui
        pnpm build
        popd
      '';
    };

    dontBuild = true;

    installPhase = ''
      install -Dt $out/bin ${finalAttrs.gephgui-wry}/bin/gephgui-wry
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
  });
}
