{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  buildGoModule,
  fetchNpmDeps,
  makeWrapper,
  nodejs,
  npmHooks,
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
  version = "4.99.32";
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
      hash = "sha256-UXu/LHFNZ+cAGxsNqyfEgFSAcm5k4RU3c2e0+fxC/Nc=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-oHbD4o7otQ8Pdo7KayO75qD0JLoNXA/CEJRX9jT8sZs=";

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
      rev = "77f7102c8ed114e931bb132fcab38c28e50a4eb5";
      hash = "sha256-MgvSR2favOJDtZNDWr3f0RILgjNavBuXZ4oMyPDjDNk=";
      fetchSubmodules = true;
    };

    gephgui-wry = rustPlatform.buildRustPackage {
      pname = "gephgui-wry";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/gephgui-wry";

      useFetchCargoVendor = true;
      cargoHash = "sha256-pCj4SulUVEC4QTPBrPQBn5xJ+sHPs6KfjsdVRcsRapY=";

      npmDeps = fetchNpmDeps {
        name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
        inherit (finalAttrs) src;
        sourceRoot = "${finalAttrs.src.name}/gephgui-wry/gephgui";
        hash = "sha256-MgVJIo7K3te99LzSwEcjJJ8XKjwGLwkJtIfyEfdsFbU=";
      };

      nativeBuildInputs = [
        pkg-config
        npmHooks.npmConfigHook
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

      env.ESBUILD_BINARY_PATH = "${lib.getExe (
        esbuild.override {
          buildGoModule =
            args:
            buildGoModule (
              args
              // rec {
                version = "0.15.18";
                src = fetchFromGitHub {
                  owner = "evanw";
                  repo = "esbuild";
                  rev = "v${version}";
                  hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
                };
                vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
              }
            );
        }
      )}";

      npmRoot = "gephgui";

      preBuild = ''
        pushd gephgui
        npm run build
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
