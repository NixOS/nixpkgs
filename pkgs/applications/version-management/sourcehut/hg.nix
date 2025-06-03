{
  lib,
  fetchFromSourcehut,
  fetchpatch,
  buildGoModule,
  buildPythonPackage,
  srht,
  python-hglib,
  scmsrht,
  unidiff,
  python,
  unzip,
  pip,
  pythonOlder,
  setuptools-scm,
}:

let
  version = "0.36.1";
  gqlgen = import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  };

  patches = [
    (fetchpatch {
      name = "update-core-go-and-gqlgen.patch";
      url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht/rev/2765f086c3a67e00219cabe9a1dd01b2012c5c12.patch";
      hash = "sha256-MLZG07tD7vrfvx2GDRUvFd/7VxxZLrAa/C3bB/IvQpI=";
    })
    ./patches/core-go-update/hg/patch-deps.patch
  ];

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hg.sr.ht";
    rev = version;
    hash = "sha256-EeWRUb/BZ+KJXNqmzCFYHkvWUaPvF/F7ZaOYM0IEYwk=";
    vc = "hg";
  };

  hgsrht-api = buildGoModule (
    {
      inherit src version patches;
      pname = "hgsrht-api";
      modRoot = "api";
      vendorHash = "sha256-elaVmyaO5IbzsnBYRjJvmoOFR8gx1xCfzd3z01KNXVA=";
    }
    // gqlgen
  );

  hgsrht-keys = buildGoModule {
    inherit src version patches;
    pname = "hgsrht-keys";
    modRoot = "keys";
    vendorHash = "sha256-U5NtgyUgVqI25XBg51U7glNRpR5MZBCcsuuR6f+gZc8=";

    postPatch = ''
      substituteInPlace keys/main.go \
        --replace-fail /var/log/hg.sr.ht-keys /var/log/sourcehut/hg.sr.ht-keys
    '';
  };
in
buildPythonPackage rec {
  inherit src version patches;
  pname = "hgsrht";

  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace hg.sr.ht-shell \
      --replace-fail /var/log/hg.sr.ht-shell /var/log/sourcehut/hg.sr.ht-shell
  '';

  nativeBuildInputs = [
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    python-hglib
    scmsrht
    srht
    unidiff
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
    ln -s ${hgsrht-api}/bin/api $out/bin/hg.sr.ht-api
    ln -s ${hgsrht-keys}/bin/hgsrht-keys $out/bin/hg.sr.ht-keys
    install -Dm644 schema.sql $out/share/sourcehut/hg.sr.ht-schema.sql
    make install-share
  '';

  pythonImportsCheck = [ "hgsrht" ];

  meta = with lib; {
    homepage = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      eadwu
      christoph-heiss
    ];
  };
}
