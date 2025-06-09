{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.0.5";
in
buildGoModule {
  pname = "met";
  inherit version;

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "met";
    tag = "v${version}";
    hash = "sha256-nfI0sJSEsKTQZkM5grUBdC7PkzTapEgF1zYzIdkoN2I=";
  };

  vendorHash = "sha256-dl90ItX62FfDAzAHHBxp4ojegGCj2oMKl47BjsD2RU0=";

  ldflags = [
    "-X=main.Version=${version}"
  ];

  meta = {
    description = "Dynamically render prometheus compatible metrics in your terminal";
    homepage = "https://github.com/jaxxstorm/met";
    changelog = "https://github.com/jaxxstorm/met/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "met";
  };
}
