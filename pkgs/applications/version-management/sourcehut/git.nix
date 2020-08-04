{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, minio, pygit2, scmsrht }:

let
  version = "0.50.3";

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-shell";

  vendorSha256 = "1zvbqn4r940mibn4h1cqz94gbr476scm281ps361n0rfqlimw8g5";
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatcher";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-dispatch";

  vendorSha256 = "1lzkf13m54pq0gnn3bcxc80nfg76hgck4l8q8jpaicrsiwgcyrd9";
  };

  buildKeys = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-keys";

  vendorSha256 = "16j7kpar318s4766pln8xn6d51xqblwig5n1jywhj0sl80qjl5cv";
  };

  buildUpdateHook = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-update-hook";

  vendorSha256 = "1rmv3p60g6w4h4v9wx99jkyx0q02snslyjrjy9n1flardjs01b63";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "gitsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    rev = version;
    sha256 = "0rxsr8cizac5xv8bgx2s1p2q4n8i5s51p9qbqdjad9z1xmwi6rvn";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    minio
    pygit2
    scmsrht
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${buildShell "${src}/gitsrht-shell"}/bin/gitsrht-shell $out/bin/gitsrht-shell
    cp ${buildDispatcher "${src}/gitsrht-dispatch"}/bin/gitsrht-dispatch $out/bin/gitsrht-dispatch
    cp ${buildKeys "${src}/gitsrht-keys"}/bin/gitsrht-keys $out/bin/gitsrht-keys
    cp ${buildUpdateHook "${src}/gitsrht-update-hook"}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
