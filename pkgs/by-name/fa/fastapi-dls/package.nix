{
  lib,
  python3,
  fetchFromGitLab,
  gitUpdater,
  makeWrapper,
}:

let

  pythonEnv = python3.withPackages (
    packages:
    with packages;
    [
      fastapi
      uvicorn
      python-jose
      pycryptodome
      python-dateutil
      sqlalchemy
      markdown
      python-dotenv
    ]
    ++ uvicorn.optional-dependencies.standard
  );

  version = "1.4.1";

in
python3.pkgs.buildPythonApplication {
  pname = "fastapi-dls";
  inherit version;
  pyproject = false;

  src = fetchFromGitLab {
    domain = "git.collinwebdesigns.de";
    owner = "oscar.krause";
    repo = "fastapi-dls";
    rev = "refs/tags/${version}";
    hash = "sha256-H4mtmJ4iQXPZFWQPm12aH/kdg9TAMgHkvkbaHfxfS3I=";
  };

  patches = [
    ./add-algorithms-argument.patch # fixes license activation
  ];

  # Don't create .orig files if the patch isn't an exact match.
  patchFlags = [
    "--no-backup-if-mismatch"
    "-p1"
  ];

  postInstall = ''
    mkdir -p $out/bin $out/share/fastapi-dls
    cp -r README.md app $out/share/fastapi-dls

    makeWrapper ${pythonEnv}/bin/uvicorn $out/bin/fastapi-dls \
      --add-flags "--app-dir $out/share/fastapi-dls/app" \
      --add-flags "--proxy-headers" \
      --add-flags "main:app"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Minimal Delegated License Service (DLS)";
    homepage = "https://git.collinwebdesigns.de/oscar.krause/fastapi-dls";
    license = lib.licenses.unfree;
    mainProgram = "fastapi-dls";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ MakiseKurisu ];
  };
}
