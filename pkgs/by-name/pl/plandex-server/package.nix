{ lib
, buildGoModule
, fetchFromGitHub
, runCommand
, git
, nix-update-script
,
}:
buildGoModule rec {
  pname = "plandex";
  version = "0.8.4";
  hash = "sha256-k9SwH+oYAd9Zr5cq0HKv5Up5j+9WiSofnKUDkBsdMWk=";

  src = fetchFromGitHub {
    owner = "plandex-ai";
    repo = "plandex";
    rev = "refs/tags/server/v${version}";
    hash = hash;
  };
  sourceRoot = "source/app/server";

  vendorHash = "sha256-JYL/NLp4ucyqPPfE45P+QQsQKSsRqkv1T13IMQYA2MY=";

  nativeCheckInputs = [
    git
  ];

  postPatch = ''
    substituteInPlace db/db.go \
      --replace "file://migrations" "file://${placeholder "out"}/share/plandex/migrations"
  '';

  postInstall = ''
    mkdir -p $out/share/plandex
    cp -a $src/app/server/migrations $out/share/plandex/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An open source, terminal-based AI coding engine for complex tasks.";
    changelog = "https://github.com/plandex-ai/plandex/releases/tag/server/v${version}";
    homepage = "https://plandex.ai/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      mattchrist
    ];
    mainProgram = "plandex-server";
  };
}
