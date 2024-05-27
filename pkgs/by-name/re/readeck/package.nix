{
  lib,
  fetchFromGitea,
  buildGoModule,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  file-compose,
}:

let
  pname = "readeck";
  version = "0.14.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "readeck";
    repo = "readeck";
    rev = version;
    hash = "sha256-BDTz90q7xAu2N9Lzg5wAUL6xXJCyn++mjmB17LiKgcU=";
  };

  npmRoot = "web";
in
buildGoModule rec {
  inherit pname version src npmRoot;

  vendorHash = "sha256-Nt42/f7SWBmcKQLnZAeoY//PqbHpyP4TIOOKjn8ZTU4=";
  npmDeps = fetchNpmDeps {
    src = "${src}/${npmRoot}";
    hash = "sha256-RK0v8B4FRQA6Ih5l9q25COLY8I6NaC1Nfr6v3r5iNa4=";
  };
  nativeBuildInputs = [
    nodejs
    file-compose
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    npm --prefix="$npmRoot" run build
    file-compose -format json docs/api/api.yaml docs/assets/api.json
    go run ./tools/docs docs/src docs/assets
  '';

  doCheck = false;

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/readeck $out/bin   
  '';


  meta = {
    changelog = "https://codeberg.org/readeck/readeck/releases/tag/${version}";
    description = "Readeck is a simple web application that lets you save the precious readable content of web pages you like and want to keep forever";
    homepage = "https://codeberg.org/readeck/readeck";
    license = lib.licenses.agpl3Only;
    mainProgram = "readeck";
    maintainers = with lib.maintainers; [ patka ];
  };
}
