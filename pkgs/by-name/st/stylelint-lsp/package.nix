{
  bash,
  fetchFromGitHub,
  lib,
  nodejs,
  pnpm_9,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stylelint-lsp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bmatcuk";
    repo = "stylelint-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mzhY6MKkXb1jFYZvs/VkGipBjBfUY3GukICb9qVQI80=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/QJ4buPOt5KFJxwsQp7L9WYE1RtODj4LMq21l99QwhA=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/${finalAttrs.pname}}
    mv {dist,node_modules} $out/lib/${finalAttrs.pname}
    echo "
      #!${lib.getExe bash}
      ${lib.getExe nodejs} $out/lib/${finalAttrs.pname}/dist/index.js \$@
    " > $out/bin/stylelint-lsp
    chmod +x $out/bin/stylelint-lsp

    runHook postInstall
  '';

  meta = with lib; {
    description = "A stylelint Language Server";
    homepage = "https://github.com/bmatcuk/stylelint-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ gepbird ];
    mainProgram = "stylelint-lsp";
    platforms = platforms.unix;
  };
})
