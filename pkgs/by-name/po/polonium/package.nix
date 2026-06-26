{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  kdePackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "polonium";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R50Br8GGVVkA/AtXvYazgBWSEax0KEvWwyFQv3zqWqU=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-T8dW+ctRlN8fIJtPKy0niWcCuQTd3GV5MbmaZf8CqZk=";

  __structuredAttrs = true;

  dontConfigure = true;

  # the installer does a bunch of stuff that fails in our sandbox, so just build here and then we
  # manually do the install
  buildFlags = [
    "res"
    "src"
  ];

  dontNpmBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kwin/scripts/polonium
    cp -a pkg/. $out/share/kwin/scripts/polonium

    runHook postInstall
  '';

  meta = {
    description = "Auto-tiler that uses KWin 6.0+ tiling functionality";
    homepage = "https://polonium.vaughanm.xyz/";
    downloadPage = "https://github.com/zeroxoneafour/polonium/releases";
    changelog = "https://github.com/zeroxoneafour/polonium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nelind
      HeitorAugustoLN
    ];
    inherit (kdePackages.kwin.meta) platforms;
  };
})
