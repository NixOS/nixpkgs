{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  jdk11,
  gradle,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kobweb-cli";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "varabyte";
    repo = "kobweb-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zNXQrzito6TGKpBDjqog7oCrhcwARCnVKH2uQjcNAtk=";
  };

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "assembleShadowDist";

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  strictDeps = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r kobweb/build/scriptsShadow/* $out/bin
    cp -r kobweb/build/libs/* $out/lib
    chmod +x $out/bin/kobweb
    wrapProgram $out/bin/kobweb \
      --prefix PATH : ${jdk11}/bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/varabyte/kobweb-cli";
    changelog = "https://github.com/varabyte/kobweb-cli/releases/tag/v${finalAttrs.version}";
    description = "CLI binary that drives the interactive Kobweb experience";
    mainProgram = "kobweb";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philippschuetz
    ];
  };
})
