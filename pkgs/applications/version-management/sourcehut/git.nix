{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  buildPythonPackage,
  python,
  srht,
  scmsrht,
  pygit2,
  minio,
  pythonOlder,
  unzip,
  pip,
  setuptools-scm,
}:
let
  version = "0.88.10";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    hash = "sha256-o7d2EIx9oJAQSIrMMG/TYjAo7PJwT6rE8kcVMKoYenY=";
  };

  patches = [ ./patches/core-go-update/git/patch-deps.patch ];

  gitApi = buildGoModule (
    {
      inherit src version patches;
      pname = "gitsrht-api";
      modRoot = "api";
      vendorHash = "sha256-20SxOZrvj41L8A5nuOro9DYiK6FyhwJK5cNAvxPB7qw=";
    }
    // gqlgen
  );

  gitDispatch = buildGoModule (
    {
      inherit src version patches;
      pname = "gitsrht-dispatch";
      modRoot = "dispatch";
      vendorHash = "sha256-MXLF7vO8SmUkU1nOxhObuzjT2ZRQQluIX7TRrxL7/3Y=";

      postPatch = ''
        substituteInPlace dispatch/main.go \
          --replace-fail /var/log/git.sr.ht-dispatch /var/log/sourcehut/git.sr.ht-dispatch
      '';
    }
    // gqlgen
  );

  gitKeys = buildGoModule (
    {
      inherit src version patches;
      pname = "gitsrht-keys";
      modRoot = "keys";
      vendorHash = "sha256-MXLF7vO8SmUkU1nOxhObuzjT2ZRQQluIX7TRrxL7/3Y=";

      postPatch = ''
        substituteInPlace keys/main.go \
          --replace-fail /var/log/git.sr.ht-keys /var/log/sourcehut/git.sr.ht-keys
      '';
    }
    // gqlgen
  );

  gitShell = buildGoModule (
    {
      inherit src version patches;
      pname = "gitsrht-shell";
      modRoot = "shell";
      vendorHash = "sha256-MXLF7vO8SmUkU1nOxhObuzjT2ZRQQluIX7TRrxL7/3Y=";

      postPatch = ''
        substituteInPlace shell/main.go \
          --replace-fail /var/log/git.sr.ht-shell /var/log/sourcehut/git.sr.ht-shell
      '';
    }
    // gqlgen
  );

  gitUpdateHook = buildGoModule (
    {
      inherit src version patches;
      pname = "gitsrht-update-hook";
      modRoot = "update-hook";
      vendorHash = "sha256-MXLF7vO8SmUkU1nOxhObuzjT2ZRQQluIX7TRrxL7/3Y=";

      postPatch = ''
        substituteInPlace update-hook/main.go \
          --replace-fail /var/log/git.sr.ht-update-hook /var/log/sourcehut/git.sr.ht-update-hook
      '';
    }
    // gqlgen
  );
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "gitsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
    scmsrht
    pygit2
    minio
  ];

  env = {
    PKGVER = version;
    SRHT_PATH = "${srht}/${python.sitePackages}/srht";
    PREFIX = placeholder "out";
  };

  postBuild = ''
    make SASSC_INCLUDE=-I${srht}/share/sourcehut/scss/ all-share
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s ${gitApi}/bin/api $out/bin/git.sr.ht-api
    ln -s ${gitDispatch}/bin/dispatch $out/bin/git.sr.ht-dispatch
    ln -s ${gitKeys}/bin/keys $out/bin/git.sr.ht-keys
    ln -s ${gitShell}/bin/shell $out/bin/git.sr.ht-shell
    ln -s ${gitUpdateHook}/bin/update-hook $out/bin/git.sr.ht-update-hook
    install -Dm644 schema.sql $out/share/sourcehut/git.sr.ht-schema.sql
    make PREFIX=$out install-share
  '';

  pythonImportsCheck = [ "gitsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
