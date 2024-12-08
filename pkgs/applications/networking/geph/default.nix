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
  webkitgtk_4_0,
  libayatana-appindicator,
  cairo,
  openssl,
}:

let
  version = "4.99.16";
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
      hash = "sha256-6YWPsSRIZpvVCIGZ1z7srobDvVzLr0o2jBcB/7kbK7I=";
    };

    cargoHash = "sha256-c9Sq3mdotvB/oNIiOLTrAAUnUdkaye7y1l+29Uwjfm8=";

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
      rev = "9f0d5c689c2cae67a4750a68295676f449724a98";
      hash = "sha256-/aHd1EDrFp1kXen5xRCCl8LVlMVH0pY8buILZri81II=";
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
        webkitgtk_4_0
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
