{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,

  nodejs,
  pnpm_9,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openlist-frontend";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "OpenListTeam";
    repo = "OpenList-Frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HYXYBK+7/Tbov55vqVmxb4Vb5yy0qqW2WheOJSfgwEs=";
  };

  i18n = fetchzip {
    url = "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v${finalAttrs.version}/i18n.tar.gz";
    hash = "sha256-zj3LQ9NfFYQavcD/W8qwLCLahsDXdaen+noFVZ8NcBg=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-0XmUcM+sZnoHF1N9gdnScGwEqH55eLv9I+7xYN7CnIA=";
  };

  buildPhase = ''
    runHook preBuild

    cp -r ${finalAttrs.i18n}/* src/lang/
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    echo -n "v${finalAttrs.version}" > $out/VERSION

    runHook postInstall
  '';

  meta = {
    description = "Frontend of OpenList";
    homepage = "https://github.com/OpenListTeam/OpenList-Frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
