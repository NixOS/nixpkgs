{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "plandex-server";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "server/v${version}";
    hash = "sha256-RVvgnQtb/asOjVpSZ3WndimsJ6foERMWS/YD20sghVE=";
  };

  postPatch = ''
    substituteInPlace db/db.go \
      --replace-fail "file://migrations" "file://$out/migrations"
  '';

  postInstall = ''
    cp -r migrations $out/migrations
  '';

  nativeCheckInputs = [ git ];

  sourceRoot = "${src.name}/app/server";

  vendorHash = "sha256-uarTWteOoAjzEHSnbZo+fEPELerpuL7UNA5pdGP5CMY=";

  meta = {
    mainProgram = "plandex-server";
    description = "AI driven development in your terminal. Designed for large, real-world tasks. The server part";
    homepage = "https://plandex.ai/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ viraptor ];
  };
}
