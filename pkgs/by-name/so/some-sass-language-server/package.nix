{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "some-sass-language-server";
  version = "2.3.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wkillerud";
    repo = "some-sass";
    rev = "some-sass-language-server@${finalAttrs.version}";
    hash = "sha256-jmpkZReeVuf10juWMy7QO/q1Sm7kye3NTpMCeB8kG48=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-sSumbDqiztUuTs+amYv83I6odbrIOOawXeJxdF2xkA4=";
  npmBuildScript = "build:production";
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{libexec,bin}
    cp -r packages/language-server $out/libexec/some-sass-language-server
    ln -s $out/libexec/some-sass-language-server/bin/some-sass-language-server $out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "some-sass-language-server@(.*)"
    ];
  };

  meta = {
    description = "Language server with improved support for SCSS, Sass indented and SassDoc";
    homepage = "https://wkillerud.github.io/some-sass";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "some-sass-language-server";
    maintainers = [ lib.maintainers.bandithedoge ];
  };
})
