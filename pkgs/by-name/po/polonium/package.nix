{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  kdePackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "polonium";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Y/9+b7BfWnAkDG9HtlxM53gvoqJGsdw6YCnietc/XM=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-LbLzoP/amLOMrXfjC3O3F0jg+zpxJvrkf0a0nB5mKnA=";

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
