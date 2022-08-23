{ lib, stdenv
, rtpPath
, vim
, vimCommandCheckHook
, vimGenDocHook
, neovimRequireCheckHook
, toVimPlugin
}:

rec {
  buildVimPlugin = attrs@{
    name ? "${attrs.pname}-${attrs.version}",
    namePrefix ? "vimplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? "",
    buildPhase ? "",
    preInstall ? "",
    postInstall ? "",
    path ? ".",
    addonInfo ? null,
    ...
  }:
    let drv = stdenv.mkDerivation (attrs // {
      name = namePrefix + name;

      inherit unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = ''
        runHook preInstall

        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target

        runHook postInstall
      '';
    });
    in toVimPlugin(drv.overrideAttrs(oa: {
      rtp = "${drv}";
    }));

  buildVimPluginFrom2Nix = attrs: buildVimPlugin ({
    # vim plugins may override this
    buildPhase = ":";
    configurePhase =":";
  } // attrs);
}
