{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  buildNpmPackage,
}:

let
  version = "3.0.0";

  pname = "discord-rich-presence-plex";

  src = fetchFromGitHub {
    owner = "phin05";
    repo = "discord-rich-presence-plex";
    rev = "v${version}";
    hash = "sha256-RvsS47059YdxKSo6sy+zglY1YxzyJmZTmo/DIKX1xqU=";
  };

  webAssets = buildNpmPackage {
    pname = "${pname}-web";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-7cp4LeXUAiIHGvLfwsIWpdqjUzemlCKVCsBZxTnPlDk=";
    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGo126Module {
  inherit version src pname;
  subPackages = [ "server/main" ];
  env.GOEXPERIMENT = "jsonv2";
  vendorHash = "sha256-B1XHMqyih3eBlRsU6s5HcGv9WY8OcXj2yGwB2jpP9HI=";
  preBuild = ''
    mkdir -p web/dist
    cp -r ${webAssets}/* web/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/drpp
  '';
  meta = {
    homepage = "https://github.com/phin05/discord-rich-presence-plex";
    description = "Displays your Plex status on Discord using Rich Presence";
    license = lib.licenses.gpl3Only;
    mainProgram = "discord-rich-presence-plex";
    maintainers = with lib.maintainers; [ hogcycle ];
  };
}
