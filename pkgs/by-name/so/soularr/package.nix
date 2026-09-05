{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "soularr";
  version = "0-unstable-2025-04-14";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrusse";
    repo = "soularr";
    rev = "df9945dcf224096a21edabfc7e98b638f3ce1191";
    hash = "sha256-HVv6Nz59M6YtdiAb30Xwv1pmZPNs0ByfozMyf5/Xhq8=";
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

  meta = {
    description = "Python script that connects Lidarr with Soulseek";
    homepage = "https://soularr.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "soularr";
  };
}
