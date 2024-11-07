{
  lib,
  buildNpmPackage,
  bruno,
  pkg-config,
}:

buildNpmPackage {
  pname = "bruno-cli";
  inherit (bruno) version src npmDepsHash;

  npmWorkspace = "packages/bruno-cli";

  nativeBuildInputs = [ pkg-config ];

  dontNpmBuild = true;
  postBuild = ''
    npm run build --workspace=packages/bruno-common
    npm run build --workspace=packages/bruno-query
    npm run build --workspace=packages/bruno-graphql-docs

    npm run sandbox:bundle-libraries --workspace=packages/bruno-js
  '';

  preFixup = ''
    cp -r packages $out/lib/node_modules/usebruno

    for item in typescript next @next @tabler pdfjs-dist @reduxjs @babel prettier @types; do
     rm -rfv $(find $out -type d -name $item)
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/bru \
      --prefix NODE_PATH : $out/lib/node_modules/usebruno/node_modules/electron-notarize/node_modules \
      --prefix NODE_PATH : $out/lib/node_modules
  '';

  buildInputs = bruno.buildInputs ++ [ ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

}
