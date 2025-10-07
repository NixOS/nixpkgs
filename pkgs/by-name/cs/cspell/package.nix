{
  lib,
  stdenv,
  nodejs,
  pnpm_10,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cspell";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "streetsidesoftware";
    repo = "cspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xQCE6YWCvlWjcpf2nCBjbdI76qejlvHdWiUCD4SZhRg=";
  };

  patches = [
    ./inject-workplace-deps.patch
  ];

  pnpmWorkspaces = [ "cspell..." ];

  prePnpmInstall = ''
    pnpm config set --location=project inject-workplace-packages true
  '';

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      patches
      prePnpmInstall
      ;
    fetcherVersion = 2;
    hash = "sha256-aE7DHyXPLziVjW9bBL98fFRiPwOFIyU5edbj8rEws6U=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "cspell..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/cspell
    mkdir $out/bin
    pnpm --filter="cspell" --offline --prod deploy $out/lib/node_modules/cspell

    ln -s $out/lib/node_modules/cspell/bin.mjs $out/bin/cspell

    runHook postInstall
  '';

  meta = {
    description = "Spell checker for code";
    homepage = "https://cspell.org";
    changelog = "https://github.com/streetsidesoftware/cspell/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cspell";
    maintainers = [ lib.maintainers.pyrox0 ];
  };
})
