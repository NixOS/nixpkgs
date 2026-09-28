{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "seowebchecker";
  version = "1.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/seowebchecker-seoaudit-sdk/-/seowebchecker-seoaudit-sdk-${version}.tgz";
    hash = "sha256-H3hEyGxih/yqehSVCPNT3updPN8kuHeHBPp4Th0fLFE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/seowebchecker-seoaudit-sdk $out/bin
    cp -r * $out/lib/node_modules/seowebchecker-seoaudit-sdk/

    makeWrapper ${nodejs}/bin/node $out/bin/seowebchecker \
      --add-flags "$out/lib/node_modules/seowebchecker-seoaudit-sdk/bin/cli.js"

    ln -s $out/bin/seowebchecker $out/bin/seowebchecker-audit

    runHook postInstall
  '';

  meta = {
    description = "Lightweight website SEO audit tool and CLI by SEOWebChecker";
    homepage = "https://seowebchecker.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "seowebchecker";
    platforms = lib.platforms.all;
  };
}
