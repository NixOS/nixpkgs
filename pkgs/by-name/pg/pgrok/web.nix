{ src
, version
, nodejs
, nodePackages
, stdenvNoCC
}:
let
  build-deps = nodePackages."pgrok-build-deps-../../by-name/pg/pgrok/build-deps";
in
stdenvNoCC.mkDerivation {
  pname = "pgrok-web";
  inherit version;
  src = "${src}/pgrokd/web";

  nativeBuildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild
    cp ${./build-deps/package.json} package.json
    ln -s ${build-deps}/lib/node_modules/pgrokd/node_modules node_modules
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';
}
