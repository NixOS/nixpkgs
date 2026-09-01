{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, electron
}:

buildNpmPackage rec {
  pname = "lumen-browser";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "network-lumen";
    repo = "browser";
    rev = "v${version}";
    hash = "sha256-soVW0Wj5Jf/GUoUc5xzGC2OROacChRMj0FR9dzqqjwk=";
  };

  npmDepsHash = "sha256-OtwQkkGzbqC9Z4qgg5A9xfFUoOsbjr7t2wGsZnNsCNY=";

  nativeBuildInputs = [ makeWrapper ];

  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = false;

  postInstall = ''
    cp -r . $out/lib/node_modules/lumen-browser/

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/lumen-browser \
      --add-flags "$out/lib/node_modules/lumen-browser/electron/main.cjs" \
      --add-flags "\$@"
  '';

  meta = with lib; {
    description = "Native browser for the Lumen ecosystem providing direct access to on-chain state and IPFS";
    homepage = "https://github.com/network-lumen/browser";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "lumen-browser";
  };
}
