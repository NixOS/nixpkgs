{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  buildNpmPackage,
  lib,
  ffmpeg,
  python3Packages,
  python3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bambuddy";
  version = "1.2.5.5";

  src = fetchFromGitHub {
    owner = "maziggy";
    repo = "bambuddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hdg4pmyu54Q4oLwoqedLCi5uDkxeZ/okdS39aLmBfUI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  frontend = buildNpmPackage {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";
    npmDepsHash = "sha256-vm6hm4bnw0gZIquXapHF7aWx7KV6ZklSwyrcY+MeqPI=";

    preBuild = "chmod -R u+w ../static";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ../static/. $out/

      runHook postInstall
    '';
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/bambuddy
    cp -r . $out/lib/bambuddy/

    rm -rf $out/lib/bambuddy/static
    ln -s ${finalAttrs.frontend} $out/lib/bambuddy/static

    mkdir -p $out/bin

    makeWrapper ${lib.getExe' finalAttrs.passthru.python "uvicorn"} $out/bin/bambuddy \
      --chdir "$out/lib/bambuddy" \
      --prefix PYTHONPATH : "$out/lib/bambuddy" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]} \
      --add-flags "backend.app.main:app"

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) frontend;

    # https://github.com/maziggy/bambuddy/blob/main/requirements.txt
    pythonPackages = with python3Packages; [
      aiofiles
      aioftp
      aiosqlite
      asyncpg
      asyncssh
      bcrypt
      certifi
      cryptography
      curl-cffi
      defusedxml
      fastapi
      fast-simplification
      greenlet
      httpx
      ldap3
      lxml
      matplotlib
      networkx
      numpy
      opencv4
      openpyxl
      paho-mqtt
      passlib
      pillow
      psutil
      pydantic
      pydantic-settings
      pyftpdlib
      pyjwt
      pyopenssl
      pyotp
      python-multipart
      pywebpush
      qrcode
      reportlab
      sqlalchemy
      trimesh
      uvicorn
      websockets
    ];

    python = python3.withPackages (_: finalAttrs.passthru.pythonPackages);

    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Self-hosted command center for Bambu Lab";
    homepage = "https://bambuddy.cool/";
    changelog = "https://github.com/maziggy/bambuddy/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onatustun ];
    mainProgram = "bambuddy";
    platforms = lib.platforms.linux;
  };
})
