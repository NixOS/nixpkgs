{ lib
  , stdenv
}:

stdenv.mkDerivation rec {
    name = "devcontainer";
    version = "0.55.0";

    src = fetchTarball {
        url = "https://registry.npmjs.org/@devcontainers/cli/-/cli-${version}.tgz";
        sha256 = "sha256:07vh9b77mphxzv2ayd0kbmc0mngk7fpkka3ly05zcnzi9qqyvmgr";
    };

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib
        cp -r $src/* $out/lib
        chmod +x $out/lib/devcontainer.js
        ln -s $out/lib/devcontainer.js $out/bin/devcontainer
    '';

    meta = with lib; {
        description = "Development container reference implementation";
        homepage = "https://containers.dev";
        license = licenses.mit;
        maintainers = with maintainers; [ joshspicer ];
    };
}
