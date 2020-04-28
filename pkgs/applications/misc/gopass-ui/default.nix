{ lib
, system
, stdenv
, fetchgit
, fetchurl
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, runCommand
, writeTextFile
, electron_7
, electron-chromedriver_3 ? null
, gifsicle
, jq
, libwebp
, mozjpeg
, nix-gitignore
, nodejs-12_x
, nodePackages
, optipng
, p7zip
, pngquant
, python2
, utillinux
, darwin
, xcbuild
, bash
, symlinkJoin
} @ args:

let
  electron = electron_7;

  # Optimize the final space taken by our derivation
  # by feeding electron builder with a tree of symlink
  # instead of real file.
  # It seem to effectively copy these symlink whenever no
  # changes are made to the file.
  symlinkedElectron = symlinkJoin {
    name = "symlinked-electron";
    paths = [ electron ];
  };

  # We found no sensible way to control electron-builder's
  # unpacked dir output location. We thus need way to
  # match what it will be on a per platform basis.
  electronBuilderUnpackedDirname =
      let
        platform = stdenv.hostPlatform.system;
        p2dn = {
          i686-linux = "linux-ia32-unpacked";
          x86_64-linux = "linux-unpacked";
          armv7l-linux = "linux-armv7l-unpacked";
          aarch64-linux = "linux-arm64-unpacked";
          x86_64-darwin = "mac";
        };
      in
    assert p2dn ? "${platform}";
    p2dn."${platform}";
in

stdenv.mkDerivation rec {
  pname = "gopass-ui";
  version = "0.7.0";
  name = "${pname}-${version}";

  nativeBuildInputs = [
    makeWrapper
    nodejs-12_x
  ];

  src = fetchFromGitHub {
    owner  = "codecentric";
    repo   = "gopass-ui";
    rev    = "v${version}";
    sha256 = "1yn8x3raj8hqc6jshqdbn6yfkh6qmp2j5i6b3xz8q02xyvb1r241";
  };

  nodeDeps = (import ./node-dependencies.nix {
      inherit system;
      pkgs = args // { inherit electron-chromedriver_3; };
      gopass-ui-src = src;
    }).package;

  buildInputs = [
    electron
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ xcbuild darwin.DarwinTools ];

  buildPhase = ''
    dev_node_modules="${nodeDeps}/lib/node_modules/${pname}/node_modules"
    ln -s -t "." "$dev_node_modules"

    export PATH="$dev_node_modules/.bin:$PATH"

    # Expansion of 'npm run build'.
    NODE_ENV=production webpack --config webpack.main.prod.config.js
    NODE_ENV=production webpack --config webpack.renderer.explorer.prod.config.js
    NODE_ENV=production webpack --config webpack.renderer.search.prod.config.js
  '';

  doCheck = true;

  checkPhase = ''
    # Expansion of 'npm run release:check'.
    tslint '{src,test,mocks}/**/*.{ts,tsx,js,jsx}' --project ./tsconfig.json
    jest --testRegex '\.test\.tsx?$'
  '';

  installPhase = ''
    ${if stdenv.isDarwin then ''
      declare out_elec_bundle_dir="$out/Applications"
      declare out_elec_exe="$out_elec_bundle_dir/Gopass UI.app/Contents/MacOS/Gopass UI"
      declare out_elec_asar="$out_elec_bundle_dir/Gopass UI.app/Contents/Resources/app.asar"
    ''
    else ''
      declare out_elec_bundle_dir="$out/lib/${pname}"
      declare out_elec_exe="$out_elec_bundle_dir/${pname}"
      declare out_elec_asar="$out_elec_bundle_dir/resources/app.asar"
    ''}
    mkdir -p "$(dirname "$out_elec_bundle_dir")"

    declare unpacked_bundle_dir="$PWD/release/${electronBuilderUnpackedDirname}"

    mk_electron_bundle_darwin() {
      # Darwin electron-builder pass. Same principle as below linux pass.
      # 'electron-builder' has some trouble working with ro 'plist'
      # file as input. We fix this here.
      declare nix_elec_path="$PWD/electron-dist"
      mkdir -p "$nix_elec_path"
      cp -r -t "$nix_elec_path/" "${symlinkedElectron}/Applications/Electron.app"
      chmod -R u+rw "$nix_elec_path"
      while read -s f; do
        declare fsl
        if fsl="$(readlink "$f")"; then
          cp --remove-destination "$fsl" "$f"
          chmod u+rw "$f"
        fi
      done < <(find "$nix_elec_path" -name '*.plist')

      declare nix_elec_v
      nix_elec_v="${electron.version}"
      CSC_IDENTITY_AUTO_DISCOVERY=false \
      electron-builder build --dir --mac -c.electronVersion="$nix_elec_v" -c.electronDist="$nix_elec_path"
    }

    mk_electron_bundle_linux() {
      # Linux electron-builder pass reusing existing nixpkgs electron build
      # and optimized to prevent files copies whenever possible (see '
      # symlinkedElectron').
      # Note that from what I can see to date, nothing we could not
      # easily replace without 'electron-builder'.
      # It simply:
      # -  creates an asar of the dist / build folder
      # -  rename the some electron files to our app's name
      # -  rm the existing default asar
      # -  copy its asar to the expected location
      declare nix_elec_path="${symlinkedElectron}/lib/electron"
      declare nix_elec_v
      nix_elec_v="${electron.version}"
      electron-builder build --dir --linux -c.electronVersion="$nix_elec_v" -c.electronDist="$nix_elec_path"
    }

    ${if stdenv.isDarwin then ''
      mk_electron_bundle_darwin
    ''
    else ''
      mk_electron_bundle_linux
    ''}

    mv "$unpacked_bundle_dir" "$out_elec_bundle_dir"
    wrapProgram "$out_elec_exe" --add-flags "'$out_elec_asar'"

    ${if ! stdenv.isDarwin then ''
      # Linux only.
      mkdir -p "$out/bin"
      ln -s -t "$out/bin" "$out_elec_exe"

      declare dist_dir="$PWD/dist"
      declare src_icon_dir="$dist_dir/assets"
      declare out_icon_dir="$out/share/icons/hicolor"

      install -d "$out_icon_dir/512x512/apps"
      install "$src_icon_dir/icon.png" "$out_icon_dir/512x512/apps/${pname}.png"
      install -d "$out_icon_dir/96x96/apps"
      install "$src_icon_dir/icon@2x.png" "$out_icon_dir/96x96/apps/${pname}.png"
      install -d "$out_icon_dir/48x48/apps"
      install "$src_icon_dir/icon-mac@2x.png" "$out_icon_dir/48x48/apps/${pname}.png"

      install -d  "$out/share/applications"
      cp $desktopItem/share/applications/* $out/share/applications
    '' else ""}
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    genericName = "Graphical user interface to gopass";
    icon = pname;
    exec = pname;
    categories = "Utility;";
  };

  passthru = {
    inherit nodeDeps;
    nixifyNodeDeps = runCommand "nixify-node-deps" {
        nativeBuildInputs = [ makeWrapper ];
      } ''
      makeWrapper "${bash}/bin/bash" "$out" \
        --add-flags "'${./nixify-node-deps.sh}' ${src}" \
        --prefix PATH : "${nodePackages.node2nix}/bin"
    '';
  };

  meta = {
    description = "Graphical user interface to gopass";
    homepage = "https://github.com/codecentric/gopass-ui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jraygauthier sikmir ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ];
  };
}
