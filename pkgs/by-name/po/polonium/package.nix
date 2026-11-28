{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  kdePackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "polonium";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+aAHM8QWbpnryLfV2aNHzWOFSghIPynsEp8m4obaPpU=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-cx+pUUxsdGzmnyTrWTrsYg+SVjGgiwkeZfCjxNwRx64=";

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
