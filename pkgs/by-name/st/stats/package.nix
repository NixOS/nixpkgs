{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  apple-sdk,
  swift,
  xcbuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.11.21";

  src = fetchFromGitHub {
    owner = "exelban";
    repo = "Stats";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-DtXIuBEUX+9tMC4OU0j77LxvBLkhFFu4vf0YFLDsaek=";
  };

  nativeBuildInputs = [
    apple-sdk
    xcbuildHook
    swift
  ];

  xcbuildFlags = [
    "-scheme"
    "Stats"
    "-configuration"
    "Release"
  ];

  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r ./build/Build/Products/Release/Stats.app "$out/Applications/Stats.app"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      donteatoreo
      emilytrau
    ];
    platforms = lib.platforms.darwin;
  };
})
