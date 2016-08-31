{ stdenv, buildEnv, fetchgit, makeWrapper, writeScript, fetchurl, zip, pkgs
, node_webkit }:

let
  name = "zed-${version}";
  version = "1.1.0";

  # When upgrading node packages:
  #   fetch package.json from Zed's repository
  #   run `node2nix -i package.json -c zed.nix -e ../../../development/node-packages/node-env.nix`
  #   and replace node.nix with new one
  node_env = (import ./zed.nix {
    inherit pkgs;
    inherit (stdenv) system;
  }).package;

  zed = stdenv.mkDerivation rec {
    inherit name version;

    src = fetchgit {
        url = "git://github.com/zedapp/zed";
        rev = "refs/tags/v${version}";
        sha256 = "1zvlngv73h968jd2m42ylr9vfhf35n80wzy616cv2ic7gmr1fl9p";
      };

    buildInputs = [ makeWrapper zip ];

    dontBuild = true;

    installPhase = ''
      export NWPATH="${node_webkit}/share/node-webkit";

      mkdir -p $out/zed

      cd ${src}/app; zip -r $out/zed/app.nw *; cd ..

      cat $NWPATH/nw $out/zed/app.nw > $out/zed/zed-bin
      cp $NWPATH/nw.pak $out/zed/
      cp nw/zed-linux $out/zed/zed
      chmod +x $out/zed/zed*
      cp Zed.desktop.tmpl Zed.svg Zed.png $out/zed
      rm $out/zed/app.nw
    '';

    postFixup = ''
      wrapProgram $out/zed/zed-bin \
        --prefix NODE_PATH : ${node_env}/lib/node_modules
    '';
  };

  zed_script = writeScript "zed.sh" ''
    if [[ $1 == http://* ]] || [[ $1 == https://* ]]; then
        PROJECT=$1
    elif [ "" != "$1" ]; then
       PROJECT=$(readlink -f $1)
    fi
    ${zed}/zed/zed-bin $PROJECT
  '';

in stdenv.mkDerivation rec {
  inherit name version;

  src = zed;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${zed_script} $out/bin/zed
  '';

  meta = {
    description = "A fully offline-capable, open source, keyboard-focused, text and code editor for power users";
    license = stdenv.lib.licenses.mit;
    homepage = http://zedapp.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
