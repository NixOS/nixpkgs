{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre_headless,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ltex-ls-plus";
  version = "17.0.1";

  src = fetchurl {
    url = "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${version}/ltex-ls-plus-${version}.tar.gz";
    sha256 = "sha256-S4d9yL4hgpdhqp6Vx87FUFqdUyj3k97QsJsGFyrDVDg=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv bin/ lib/ $out
    rm -fv $out/bin/.lsp-cli.json $out/bin/*.bat
    wrapProgram $out/bin/ltex-ls-plus --set JAVA_HOME "${jre_headless}"
    wrapProgram $out/bin/ltex-cli-plus --set JAVA_HOME "${jre_headless}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ltex-plus.github.io/ltex-plus/";
    description = "Grammar and spell checker using LanguageTool with support for LaTeX, Markdown, and more";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pwoelfel ];
    platforms = jre_headless.meta.platforms;
  };
}
