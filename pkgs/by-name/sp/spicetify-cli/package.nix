{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  spicetify-cli,
}:
buildGoModule (finalAttrs: {
  pname = "spicetify-cli";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-beMxE5ZpFqilgk4Xa0mvJyexDAFdwKUa1rJipFXBM7I=";
  };

  vendorHash = "sha256-UwZ5wtZ5akmn3GF93XAqJqr9mUfbFQTD/LU8YUeoaGA=";

  postPatch = ''
    substituteInPlace src/preprocess/preprocess.go \
      --replace-fail 'version != "Dev"' 'version != "${finalAttrs.version}"'
  '';

  ldflags = [
    "-s -w"
    "-X 'main.version=${finalAttrs.version}'"
  ];

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
      cp $src/css-map.json $out/share/spicetify/css-map.json

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
