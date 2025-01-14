{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm_9,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "emmet-language-server";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = "emmet-language-server";
    rev = "v${version}";
    hash = "sha256-R20twrmfLz9FP87qkjgz1R/n+Nhzwn22l9t/2fyuVeM=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-5Q1H3A3S+1VRKLXouodKxVvcnUTZz0B6PMFMBe/8+nc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    # TODO: use deploy after resolved https://github.com/pnpm/pnpm/issues/5315
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/emmet-language-server}
    mv {node_modules,dist} $out/lib/emmet-language-server
    ln -s $out/lib/emmet-language-server/dist/index.js $out/bin/emmet-language-server
    chmod +x $out/bin/emmet-language-server

    runHook postInstall
  '';

  meta = {
    description = "Language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    changelog = "https://github.com/olrtg/emmet-language-server/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "emmet-language-server";
  };
}
