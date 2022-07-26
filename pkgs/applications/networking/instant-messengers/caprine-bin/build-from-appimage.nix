{ lib
, fetchurl
, appimageTools
, xorg
, pname
, version
, sha256
, metaCommon ? { }
}:

let
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/sindresorhus/caprine/releases/download/v${version}/Caprine-${version}.AppImage";
    name = "Caprine-${version}.AppImage";
    inherit sha256;
  };
  extracted = appimageTools.extractType2 { inherit name src; };
in
(appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  extraInstallCommands = ''
    mv $out/bin/{${name},caprine}

    mkdir -p $out/share
    "${xorg.lndir}/bin/lndir" -silent "${extracted}/usr/share" "$out/share"
    ln -s ${extracted}/caprine.png $out/share/icons/caprine.png
    mkdir $out/share/applications
    cp ${extracted}/caprine.desktop $out/share/applications/
    substituteInPlace $out/share/applications/caprine.desktop \
        --replace AppRun caprine
  '';

  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
    mainProgram = "caprine";
  };
}) // {
  inherit pname version;
}
