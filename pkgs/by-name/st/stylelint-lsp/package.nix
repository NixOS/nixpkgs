{ stdenv
, fetchFromGitHub
, fetchPnpmDeps
, lib
, nodePackages
, pnpmConfigHook
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stylelint-lsp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bmatcuk";
    repo = "stylelint-lsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mzhY6MKkXb1jFYZvs/VkGipBjBfUY3GukICb9qVQI80=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    nodePackages.pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) src pname ;
    hash = "sha256-biPQAktBb230/QJHKVIh3JTjEI2zcxR3B5AQOkZqvDo=";
  };

  postBuild = ''
    pnpm build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/${finalAttrs.pname}}
    mv {dist,node_modules} $out/lib/${finalAttrs.pname}
    echo "
      #!${lib.getExe bash}
      ${lib.getExe nodePackages.nodejs} $out/lib/${finalAttrs.pname}/dist/index.js \$@
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
  };
})
