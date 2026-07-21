{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  spicetify-cli,
  nodejs,
  esbuild,
}:
buildGoModule (finalAttrs: {
  pname = "spicetify-cli";
  version = "2.44.0";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4RRy1mmqjKxDUqSV7W6KHZZcbsJvnB2hZpys1MPip3E=";
  };

  vendorHash = "sha256-FTTJJrPFqqWLBBQ6pQ0RZRaWUZ4MxsV5e9HGPOp2jOY=";

  postPatch = ''
    substituteInPlace src/preprocess/preprocess.go \
      --replace-fail 'version != "Dev"' 'version != "${finalAttrs.version}"'
  '';

  ldflags = [
    "-s -w"
    "-X 'main.version=${finalAttrs.version}'"
  ];

  nativeBuildInputs = [
    nodejs
    esbuild
  ];

  postBuild = ''
    esbuild ./src/jsHelper/spicetifyWrapper/index.js \
      --bundle --minify --target=chrome108 --format=iife \
      --outfile=spicetifyWrapper.js
  '';

  postInstall =
    /*
      jsHelper and css-map.json are required at runtime
      and are looked for in the directory of the spicetify binary
      so here we move spicetify to /share/spicetify
      so that css-map.json and jsHelper don't pollute PATH
    */
    ''
      mkdir -p $out/share/spicetify

      cp -r $src/jsHelper $out/share/spicetify/jsHelper
      chmod -R u+w $out/share/spicetify/jsHelper
      cp $src/css-map.json $out/share/spicetify/css-map.json
      cp spicetifyWrapper.js $out/share/spicetify/jsHelper/spicetifyWrapper.js

      mv $out/bin/cli $out/share/spicetify/spicetify

      ln -s $out/share/spicetify/spicetify $out/bin/spicetify
    '';

  passthru.tests.version = testers.testVersion { package = spicetify-cli; };

  meta = {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mdarocha
      gerg-l
    ];
    mainProgram = "spicetify";
  };
})
