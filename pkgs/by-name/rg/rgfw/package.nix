{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  copyPkgconfigItems,
  makePkgconfigItem,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rgfw";
  version = "1.8.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ColleagueRiley";
    repo = "RGFW";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QHgs1JVv+aCs9HOd7leTS7fmKNN4uaoYgb67rZZVncA=";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "rgfw";
      inherit (finalAttrs) version;
      inherit (finalAttrs.meta) description;
      cflags = [ "-I${variables.includedir}" ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
      };
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 RGFW.h $out/include/RGFW.h
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight single-header cross-platform library for general windowing";
    homepage = "https://github.com/ColleagueRiley/RGFW";
    changelog = "https://github.com/ColleagueRiley/RGFW/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ thekylehuang ];
    platforms = lib.platforms.all;
  };
})
