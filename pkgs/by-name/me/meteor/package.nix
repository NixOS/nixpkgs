{
  stdenv,
  lib,
  fetchurl,
  zlib,
  curl,
  xz,
  openssl,
  patchelf,
  runtimeShell,
}:

let
  version = "3.4";

  inherit (stdenv.hostPlatform) system;

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://static.meteor.com/packages-bootstrap/${version}/meteor-bootstrap-os.linux.x86_64.tar.gz";
      hash = "sha256-tzzRN9UAH7+BM3fs76U5H20vD0LGMpdrMDDiJtchgEg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://static.meteor.com/packages-bootstrap/${version}/meteor-bootstrap-os.osx.x86_64.tar.gz";
      hash = "sha256-Z9Had9hscEjxHch19KCYUTqN4OikYLfz1tqEpyxw2Y8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://static.meteor.com/packages-bootstrap/${version}/meteor-bootstrap-os.osx.arm64.tar.gz";
      hash = "sha256-AT7njZTgf/WTHlvLEbF3dXKNoqyqHy8KloBQ4gsbPuM=";
    };
  };
in

stdenv.mkDerivation {
  inherit version;
  pname = "meteor";
  src = srcs.${system} or (throw "unsupported system ${system}");

  #dontStrip = true;

  sourceRoot = ".meteor";

  installPhase = ''
    mkdir $out

    cp -r packages $out
    chmod -R +w $out/packages

    cp -r package-metadata $out

    devBundle=$(find $out/packages/meteor-tool -name dev_bundle)
    ln -s $devBundle $out/dev_bundle

    toolsDir=$(dirname $(find $out/packages -print | grep "meteor-tool/.*/tools/index.js$"))
    ln -s $toolsDir $out/tools

    # Meteor needs an initial package-metadata in $HOME/.meteor,
    # otherwise it fails spectacularly.
    mkdir -p $out/bin
    cat << EOF > $out/bin/meteor
    #!${runtimeShell}

    if [[ ! -f \$HOME/.meteor/package-metadata/v2.0.1/packages.data.db ]]; then
      mkdir -p \$HOME/.meteor/package-metadata/v2.0.1
      cp $out/package-metadata/v2.0.1/packages.data.db "\$HOME/.meteor/package-metadata/v2.0.1"
      chown "\$(whoami)" "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
      chmod +w "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
    fi

    $out/dev_bundle/bin/node --no-wasm-code-gc \''${TOOL_NODE_FLAGS} $out/tools/index.js "\$@"
    EOF
    chmod +x $out/bin/meteor
  '';

  postFixup = ''
    # Remove dangling symlinks
    find $out -xtype l -ls -exec rm {} \;
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Patch Meteor to dynamically fixup shebangs and ELF metadata where
    # necessary.
    pushd $out
    patch -p1 < ${./main.patch}
    popd
    substituteInPlace $out/tools/cli/main.js \
      --replace-fail "@INTERPRETER@" "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace-fail "@RPATH@" "${
        lib.makeLibraryPath [
          curl
          stdenv.cc.cc
          xz
          zlib
        ]
      }" \
      --replace-fail "@PATCHELF@" "${patchelf}/bin/patchelf"

    # Patch node.
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$(patchelf --print-rpath $out/dev_bundle/bin/node):${lib.getLib stdenv.cc.cc}/lib" \
      $out/dev_bundle/bin/node

    # Patch mongo.
    for p in $out/dev_bundle/mongodb/bin/mongo{d,s}; do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "$(patchelf --print-rpath $p):${
          lib.makeLibraryPath [
            curl
            openssl
            stdenv.cc.cc
            xz
            zlib
          ]
        }" \
        $p
    done

    # Patch node dlls.
    for p in $(find $out/packages -name '*.node'); do
      patchelf \
        --set-rpath "$(patchelf --print-rpath $p):${lib.getLib stdenv.cc.cc}/lib" \
        $p || true
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Complete open source platform for building web and mobile apps in pure JavaScript";
    homepage = "https://www.meteor.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "meteor";
  };
}
