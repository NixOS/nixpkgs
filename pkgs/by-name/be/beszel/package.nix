{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  bun,
  nodejs-slim,
}:
buildGoModule rec {

  pname = "beszel-hub";
  version = "0.7.4";

  repo = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    rev = "v${version}";
    hash = "sha256-IXVDpi8mtlk01BKIpH3a9yUZg/2ZfDa/JrPIIcgzO+E=";
  };

  webui = stdenv.mkDerivation {
    pname = "beszel-hub-webui";
    inherit version;
    src = repo;
    sourceRoot = "${src.name}/beszel/site";

    depsBuildBuild = [
      bun
      nodejs-slim
    ];

    configurePhase = ''
      bun install --frozen-lockfile

      # `bun run` below will execute scripts that `bun install` dowloaded in
      # node_modules.
      # Since some of these scripts' shebangs reference /usr/bin/env, which is
      # not available in the build sandbox, we'll need to patch them.
      patchShebangs --build node_modules
    '';

    buildPhase = ''
      bun run build

      # Nix will complain about references to the nix store (the ones we
      # introduced above with patchShebangs) and we only need site/dist so
      # let's just get rid of the whole site/node_modules directory.
      # rm -fr node_modules
    '';

    installPhase = ''
      mkdir -p $out
      cp -r --reflink=auto dist/* $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Pgc+npTmCHEnZbYhmrtZ8ez4LDUiWbmL8BxmYrQCsPA=";

  };

  src = repo;
  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-5+/xzgVVQiooXmbJ+8WCCgUJKTQwJECEUcYt7qoEEJs=";

  ldflags = [ "-w -s" ];

  subPackages = [ "cmd/hub" ];

  preBuild = ''
    mkdir -p site/dist
    cp -r --reflink=auto ${webui}/* site/dist
  '';

  postInstall = ''
    mv $out/bin/hub $out/bin/${meta.mainProgram}
  '';

  meta = {
    description = "Hub for the Beszel server monitoring system.";
    mainProgram = "beszel";
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bot-wxt1221
      giorgiga
    ];
  };

}
