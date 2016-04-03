{ callPackage, stdenv, fetchurl, makeWrapper
, jq, xlibs, gtk, python, nodejs
, ...
} @ args:

let
  electron = callPackage ../../../development/tools/electron/default.nix (args // rec {
    version = "0.35.6";
    sha256 = "1bwn14769nby04zkza9jphsya2p6fjnkm1k2y4h5y2l4gnqdvmx0";
  });
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    version = "0.10.10";

    src = fetchurl {
      url = "https://github.com/Microsoft/vscode/archive/${version}.tar.gz";
      sha256 = "1mzkip6621111xwwksqjad1kgpbhna4dhpkf6cnj2r18dkk2jmcw";
    };

    buildInputs = [ makeWrapper jq xlibs.libX11 xlibs.xproto gtk python nodejs electron ];

    extensionGalleryJSON = ''
      {
        \"extensionsGallery\": {
          \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",
          \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",
          \"itemUrl\": \"https://marketplace.visualstudio.com/items\"
        }
      }
    '';

    configurePhase = ''
      # PATCH SCRIPT SHEBANGS
      echo "PATCH SCRIPT SHEBANGS"
      patchShebangs ./scripts

      # ADD EXTENSION GALLERY URLS TO APPLICATION CONFIGURATION
      echo "AUGMENT APPLICATION CONFIGURATION"
      echo "$(cat ./product.json) ${extensionGalleryJSON}" | jq -s add  > tmpFile && \
        mv tmpFile ./product.json
    '';

    buildPhase  = ''
      # INSTALL COMPILE- & RUN-TIME DEPENDENCIES
      echo "INSTALL COMPILE- & RUN-TIME DEPENDENCIES"
      mkdir -p ./tmp
      HOME=./tmp ./scripts/npm.sh install

      # COMPILE SOURCES
      echo "COMPILE SOURCES"
      ./node_modules/.bin/gulp
    '';

    doCheck = true;
    checkPhase = ''
      # CHECK APPLICATION
      echo "CHECK APPLICATION"
      ATOM_SHELL_INTERNAL_RUN_AS_NODE=1 ${electron}/bin/electron ./node_modules/.bin/_mocha
    '';

    installPhase = ''
      # COPY FILES NEEDED FOR RUNNING APPLICATION TO OUT DIRECTORY
      echo "COPY FILES NEEDED FOR RUNNING APPLICATION TO OUT DIRECTORY"
      mkdir -p "$out"
      cp -R ./.vscode "$out"/.vscode
      cp -R ./extensions "$out"/extensions
      cp -R ./out "$out"/out
      cp -R ./node_modules "$out"/node_modules
      cp ./package.json "$out"/package.json
      cp ./product.json "$out"/product.json
      cp ./tslint.json "$out"/tslint.json
      # COPY LEGAL STUFF
      cp ./LICENSE.txt "$out"/LICENSE.txt
      cp ./OSSREADME.json "$out"/OSSREADME.json
      cp ./ThirdPartyNotices.txt "$out"/ThirdPartyNotices.txt

      # CREATE RUNNER SCRIPT
      echo "CREATE RUNNER SCRIPT"
      mkdir -p "$out"/bin
      makeWrapper "${electron}/bin/electron" "$out/bin/vscode" \
      --set VSCODE_DEV 1 \
      --add-flags "$out"
    '';

    meta = with stdenv.lib; {
      description = "Visual Studio Code is an open source source code editor developed by Microsoft for Windows, Linux and OS X.";
      longDescription = ''
        Visual Studio Code is an open source source code editor developed by Microsoft for Windows, Linux and OS X.
        It includes support for debugging, embedded Git control, syntax highlighting, intelligent code completion, snippets, and code refactoring.
        It is also customizable, so users can change the editor's theme, keyboard shortcuts, and preferences.
      '';
      homepage = http://code.visualstudio.com/;
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  }
