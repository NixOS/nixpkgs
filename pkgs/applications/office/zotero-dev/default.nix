{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, fetchzip
, firefox-esr-102-unwrapped
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, python3
, unzip
, zip
, perl
, rsync
, wrapGAppsHook
, gsettings-desktop-schemas
, glib
, gtk3
, gnome
, dconf
, coreutils
}:

let
  pname = "zotero-dev";
  version = "7.0.0";
  rev = "096a3c5f2f57fffdecf001981129e13a1791ad89";

  meta = with lib; {
    description = "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources";
    homepage = "https://github.com/zotero/zotero";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn ];
    platforms = platforms.unix;
  };

  pdftools = let pdftools-version = "0.0.5"; in
    fetchzip {
      url = "https://zotero-download.s3.amazonaws.com/pdftools/pdftools-${pdftools-version}.tar.gz";
      hash = "sha256-cvd0cJcuhSd2BTgRc5mz0bP9DakEKG/LK2onKOhes04=";
      stripRoot = false;
    };

  zotero-client =
    let
      npmFlags = [ "--legacy-peer-deps" ];
      NODE_OPTIONS = "--openssl-legacy-provider";

      single-file = buildNpmPackage {
        pname = "${pname}-single-file";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "gildas-lormeau";
          repo = "SingleFile";
          rev = "999976a20afb51a18da4abb42f434eac99796e84";
          hash = "sha256-fHKVn9DTwshfBXf0nxCk0MLY1fEiQXD/SZPG1bICHo8=";
        };

        npmDepsHash = "sha256-L4LuD7n8c42TPpbLWuJzeM27xcsXVdBnMTqNvRZMdz8=";
        dontNpmBuild = true;
      };

      xpcom-utilities = buildNpmPackage {
        pname = "${pname}-xpcom-utilities";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "zotero";
          repo = "utilities";
          rev = "b93f16dba483891c0ab4627cbaa303de5c7fa0c0";
          hash = "sha256-Oz3h6aGorAm+Y5JZSclfz40YRj+uSPW2a5jgQWszLsk=";
        };

        npmDepsHash = "sha256-tWDADhAeXG0HSvFnpdGOya3CjSb0i2aR3E1Y3r1J81o=";
        dontNpmBuild = true;
      };

      note-editor = buildNpmPackage {
        pname = "${pname}-note-editor";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "zotero";
          repo = "note-editor";
          rev = "076f5b3d3609051b9cba3cd68c4bb22746187834";
          hash = "sha256-ZDmb3DQttftfS4w5+HlkTXRxhRYftBh1bm6MI+RBvII=";
        };

        npmDepsHash = "sha256-yu2s4V2hB07eS0INVxQXU7YeWYmR3p4JPxKWuCK3Iys=";

        postInstall = ''
          cp -r build $out/lib/node_modules/zotero-note-editor/build
        '';
      };

      translators = buildNpmPackage {
        pname = "${pname}-translators";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "zotero";
          repo = "translators";
          rev = "3a9544d7b0b6fdcb6cdcbc8c08392f91d20d99b4";
          hash = "sha256-XX1iBjuaFpmtkKTHuFPTtZOcFZk+oF8C8d2DPnENjV4=";
        };

        npmDepsHash = "sha256-lHSUID8Gv+Rw6Ed+3SbxzdjvxFoCGiyY6BXb0U2A1eo=";

        postPatch = ''
          rm package-lock.json
          cp ${./translator-lock.json} package-lock.json

          # Remove unused dependency
          sed -i package.json -e '/eslint-plugin-zotero-translator/d'

          # Avoid downloading binary in sandbox
          echo "chromedriver_skip_download=true" >> .npmrc
        '';

        dontNpmBuild = true;
      };

      pdf-reader-pdfjs = buildNpmPackage {
        pname = "${pname}-pdf-reader-pdfjs";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "zotero";
          repo = "pdf.js";
          rev = "336247a15be77f2e253599f810a8cda107171566";
          hash = "sha256-GBEBTyFMh+zi0KiHLNGfZi/XW9mhm3x0uCJkA7ml7mk=";
        };

        npmDepsHash = "sha256-9e90iIKwWyBq68q/CKn+7laJwPFtJaZtblcWpIEDSXw=";
        makeCacheWritable = true;

        postPatch = ''
          # Add a version number
          sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
        '';

        buildPhase = ''
          node_modules/.bin/gulp generic
        '';

        postInstall = ''
          cp -r build $out/lib/node_modules/pdf.js/build
        '';
      };

      pdf-worker-pdfjs = buildNpmPackage {
        pname = "${pname}-pdf-worker-pdfjs";
        inherit version npmFlags NODE_OPTIONS meta;

        src = fetchFromGitHub {
          owner = "zotero";
          repo = "pdf.js";
          rev = "e198a17afc6f56e0a9d48b07e42ec80645a7a0a8";
          hash = "sha256-FlKII11oPMPka+96Wo9ZjBuNp40i3OMuvlNz8X/r0Lw=";
        };

        npmDepsHash = "sha256-9e90iIKwWyBq68q/CKn+7laJwPFtJaZtblcWpIEDSXw=";
        makeCacheWritable = true;

        postPatch = ''
          # Add a version number
          sed -i package*.json -e '/"name": "pdf.js"/a "version": "1.0.0",'
        '';

        buildPhase = ''
          node_modules/.bin/gulp lib
        '';

        postInstall = ''
          cp -r build $out/lib/node_modules/pdf.js/build
        '';
      };

      pdf-reader = buildNpmPackage {
        pname = "${pname}-pdf-reader";
        src = fetchFromGitHub {
          owner = "zotero";
          repo = "pdf-reader";
          rev = "3b7f54727fdd8f238281a555988ada4615679b9c";
          hash = "sha256-Y49bT08Z9ESK3yVkRQT67oU9jygr5xblHgUiX/SwyLE=";
        };
        inherit version npmFlags NODE_OPTIONS meta;
        npmDepsHash = "sha256-tDr2WLnpltWPrlF21M8G/We4zzAXBp4px5xceOVLbhQ=";

        postPatch = ''
          # Avoid npm install since it is handled by buildNpmPackage
          sed -i scripts/build-pdfjs \
            -e 's/npx gulp/#npx gulp/g' \
            -e 's/npm ci/#npm ci/g'
        '';

        buildPhase = ''
          rm -rf pdf.js
          cp -Lr ${pdf-reader-pdfjs}/lib/node_modules/pdf.js pdf.js
        '';

        preInstall = ''
          mkdir -p $out/lib/node_modules/pdf-reader
          cp -r node_modules $out/lib/node_modules/pdf-reader/node_modules
        '';
      };

      pdf-worker = buildNpmPackage {
        pname = "${pname}-pdf-worker";
        src = fetchFromGitHub {
          owner = "zotero";
          repo = "pdf-worker";
          rev = "582f5d6cf91c5f09fc7898c3eced0ad32cbfccb1";
          hash = "sha256-y1nEYGbtZzsc1Hn9B/Cvom3f7+OsYgwOuWFfp5U4gjc=";
        };
        inherit version npmFlags NODE_OPTIONS meta;
        npmDepsHash = "sha256-rO/P7/22erxNeOpR8ph7taKyCeOEG9+U06oOfmPSa3w=";

        postPatch = ''
          # Avoid npm install since it is handled by buildNpmPackage
          sed -i scripts/build-pdfjs \
            -e 's/npx gulp/#npx gulp/g' \
            -e 's/npm ci/#npm ci/g'
        '';

        buildPhase = ''
          rm -rf pdf.js
          cp -Lr ${pdf-worker-pdfjs}/lib/node_modules/pdf.js pdf.js
        '';

        preInstall = ''
          mkdir -p $out/lib/node_modules/pdf-worker
          cp -r node_modules $out/lib/node_modules/pdf-worker/node_modules
        '';
      };
    in
    buildNpmPackage {
      pname = "${pname}-client";
      inherit version npmFlags NODE_OPTIONS meta;

      src = fetchFromGitHub {
        owner = "zotero";
        repo = "zotero";
        inherit rev;
        hash = "sha256-XGpk2CYgdaFCJJJc2XhW2fVD+dbACUkGClgwLoNMOoM=";
        fetchSubmodules = true;
      };

      npmDepsHash = "sha256-b9MCHtt4Ewpt/prEMKtzSbLv3xnP2lnhclu4xDh1QGQ=";

      postPatch = ''
        rm -rf resource/SingleFile
        cp -Lr ${single-file}/lib/node_modules/single-file resource/SingleFile

        rm -rf chrome/content/zotero/xpcom/utilities
        cp -Lr ${xpcom-utilities}/lib/node_modules/@zotero/utilities chrome/content/zotero/xpcom/utilities

        rm -rf pdf-reader
        cp -r ${pdf-reader}/lib/node_modules/pdf-reader pdf-reader

        rm -rf pdf-worker
        cp -r ${pdf-worker}/lib/node_modules/pdf-worker pdf-worker

        chmod +w . -R

        (
          cd pdf-reader
          rm -rf pdf.js
          cp -Lr ${pdf-reader-pdfjs}/lib/node_modules/pdf.js pdf.js
        )
        (
          cd pdf-worker
          rm -rf pdf.js
          cp -Lr ${pdf-worker-pdfjs}/lib/node_modules/pdf.js pdf.js
        )

        rm -rf translators
        cp -Lr ${translators}/lib/node_modules/translators-check translators

        rm -rf note-editor
        cp -Lr ${note-editor}/lib/node_modules/zotero-note-editor note-editor

        chmod +w . -R

        # Avoid npm install and using git
        find scripts -type f | xargs sed -i 's/npm ci/#npm ci/g'
        find scripts -type f | xargs sed -i 's/git/#git/g'

        # Avoid npm build since it is already built
        sed -i scripts/note-editor.js -e 's/npm run build/#npm run build/g'
      '';

      nativeBuildInputs = [ rsync ];

      installPhase = ''
        mkdir $out
        cp -r . $out
      '';
    };

  zotero-build = stdenv.mkDerivation {
    pname = "${pname}-build";
    inherit version meta;

    src = fetchFromGitHub {
      owner = "zotero";
      repo = "zotero-build";
      rev = "00e854c6588f329b714250e450f4f7f663aa0222";
      hash = "sha256-Gvt37jObgSQ10GBYjnCLu5XbUAy3oVTkWPvHbhLF+fw=";
      fetchSubmodules = true;
    };

    postPatch = ''
      # Make the copied files writable during rsync
      sed -i xpi/build_xpi -Ee "/-aL/a '--chmod=Du=rwx',"
    '';

    buildInputs = [ python3 rsync perl ];

    buildPhase = ''
      python3 xpi/build_xpi -s ${zotero-client}/build -c source -m ${rev}
    '';

    installPhase = ''
      mkdir $out
      cp -r . $out
    '';
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${pname} -url %U";
    icon = "zotero";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = [ "Office" "Database" ];
    startupNotify = true;
    startupWMClass = pname;
    mimeTypes = [ "x-scheme-handler/zotero" "text/plain" ];
    terminal = false;
    actions = {
      profile-manager-window = {
        name = "Profile Manager";
        exec = "${pname} -P";
      };
    };
  };
in

stdenv.mkDerivation {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero-standalone-build";
    rev = "e9ef6bf21d39cc66f1edefdd5b7429bbaf0c5247";
    hash = "sha256-NcnbqCN6Pti2KuVX79QLrTk2V/3sMxMrbgRzSTluOtM=";
    fetchSubmodules = true;
  };

  patches = [ ./fetchxul.patch ];

  postPatch = ''
    patchShebangs fetch_xulrunner.sh build.sh scripts/dir_build

    # Correct the paths in config variables
    sed -i config.sh \
      -e 's|LINUX_i686_RUNTIME_PATH=.*|LINUX_i686_RUNTIME_PATH="$DIR/xulrunner/firefox"|' \
      -e 's|LINUX_x86_64_RUNTIME_PATH=.*|LINUX_x86_64_RUNTIME_PATH="$DIR/xulrunner/firefox"|' \
      -e 's|ZOTERO_SOURCE_DIR=.*|ZOTERO_SOURCE_DIR="${zotero-client}"|' \
      -e 's|ZOTERO_BUILD_DIR=.*|ZOTERO_BUILD_DIR="${zotero-build}"|'

    # Use the hash from this revision and avoid building xpi
    sed -i scripts/dir_build \
      -Ee 's|(.*hash=).*|\1${rev}|' \
      -e '/build_xpi/d'

    # Make the copied files writable after rsync
    sed -i build.sh -Ee 's|(rsync -a.*)|\1; chmod -R +w $BUILD_DIR|'
  '';

  nativeBuildInputs = [ makeWrapper python3 unzip zip perl rsync wrapGAppsHook copyDesktopItems ];
  buildInputs = [ gsettings-desktop-schemas glib gtk3 gnome.adwaita-icon-theme dconf ];

  configurePhase = ''
    mkdir xulrunner
    cp -Lr ${firefox-esr-102-unwrapped}/lib/firefox xulrunner
    chmod -R +w xulrunner

    cp -Lr ${pdftools} pdftools
    chmod -R +w pdftools

    ./fetch_xulrunner.sh -p l
  '';

  buildPhase = ''
    chmod -R +w /build
    scripts/dir_build -p l
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -Lr staging/Zotero_linux $out/lib/zotero
    ln -s $out/lib/zotero/zotero $out/bin

    for size in 16 32 48 256; do
      install -Dm444 staging/Zotero_linux/chrome/icons/default/default$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
      --set-default MOZ_ENABLE_WAYLAND 1
    )
  '';
}
