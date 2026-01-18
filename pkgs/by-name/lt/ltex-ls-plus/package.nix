{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre_headless,
  jvmOptions ? [ ],
}:

stdenvNoCC.mkDerivation rec {
  pname = "ltex-ls-plus";
  version = "18.6.1";

  src = fetchurl {
    url = "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${version}/ltex-ls-plus-${version}.tar.gz";
    sha256 = "sha256-YhuT1ZKpecysA4DuMrgko77L0t0Ve9VanXWHbX8p3qo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase =
    let
      java_opts = lib.optionalString (jvmOptions != [ ]) ''--set JAVA_OPTS "${toString jvmOptions}"'';
    in
    ''
      runHook preInstall

      mkdir -p $out
      cp -rfv bin/ lib/ $out
      rm -fv $out/bin/.lsp-cli.json $out/bin/*.bat
      for file in $out/bin/{ltex-ls-plus,ltex-cli-plus}; do
        wrapProgram $file --set JAVA_HOME "${jre_headless}" ${java_opts}
      done

      runHook postInstall
    '';

  meta =
    let
      inherit (lib) licenses maintainers;
    in
    {
      homepage = "https://ltex-plus.github.io/ltex-plus/";
      description = "LSP language server for LanguageTool";
      license = licenses.mpl20;
      mainProgram = "ltex-cli-plus";
      maintainers = [ maintainers.FirelightFlagboy ];
      platforms = jre_headless.meta.platforms;
    };
}
