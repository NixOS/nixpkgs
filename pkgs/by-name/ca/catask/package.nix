{
  lib,
  stdenv,
  fetchFromGitea,
  python3Packages,
  postgresql,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catask";
  version = "2.7.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "catask-org";
    repo = "catask";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aX93g1sFg93uR6XoO5OZ6kRy9kRVd6RCOBviS1zA/Ig=";
  };

  propagatedBuildInputs = [
    (python3Packages.python.withPackages (
      ps: with ps; [
        flask
        gunicorn
        markupsafe
        pillow
        python-dotenv
        psycopg
        humanize
        mistune
        bleach
        pathlib2
        flask-babel
        flask-compress
        requests
        yoyo-migrations
        ago
        lupa
        authlib
        sentry-sdk
        mastodon-py
      ]
    ))
    postgresql
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/share/catask
    cp -R * -t $out/share/catask
  '';

  # Semi-opinionated script to allow running, more configuration is available in the NixOS module
  preFixup = ''
    makeWrapper "${lib.getExe python3Packages.gunicorn}" "$out/bin/catask" \
      --add-flags "-w" \
      --add-flags "4" \
      --add-flags "--pythonpath" \
      --add-flags "$out/share/catask" \
      --add-flags "app:app" \
      --prefix PATH : "${lib.makeBinPath finalAttrs.propagatedBuildInputs}"

      makeWrapper "${lib.getExe python3Packages.flask}" "$out/bin/catask-init-db" \
      --chdir "$out/share/catask" \
      --add-flags "init-db" \
      --set-default PYTHONDONTWRITEBYTECODE "true" \
      --prefix PATH : "${lib.makeBinPath finalAttrs.propagatedBuildInputs}"
  '';

  meta = {
    description = "CatAsk is a simple & easy to use Q&A software that makes answering questions easier.";
    homepage = "https://catask.org/";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.luNeder ];
    mainProgram = "catask";
  };
})
