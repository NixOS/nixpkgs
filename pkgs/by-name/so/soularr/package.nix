{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "soularr";
  version = "1.2.2";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mrusse";
    repo = "soularr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gtz99+DiFjJZuq54qo5C+5Exx++S+ePzldgDM9NHAOA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    music-tag
    pyarr
    slskd-api
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mv soularr{.py,}
    installBin soularr

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python script that connects Lidarr with Soulseek";
    homepage = "https://soularr.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hougo ];
    mainProgram = "soularr";
  };
})
