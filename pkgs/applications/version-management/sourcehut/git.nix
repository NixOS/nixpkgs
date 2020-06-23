{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, minio, pygit2, scmsrht }:

let
  version = "0.60.7";

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";

    vendorSha256 = "1zvbqn4r940mibn4h1cqz94gbr476scm281ps361n0rfqlimw8g5";

    doCheck = false;
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatcher";

    vendorSha256 = "1lzkf13m54pq0gnn3bcxc80nfg76hgck4l8q8jpaicrsiwgcyrd9";

    doCheck = false;
  };

  buildKeys = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";

    vendorSha256 = "08g3cvxq2zkdqbbb9r9rvdg23fs7hn5zqf7fzhr792f6mshdm5v2";

    doCheck = false;
  };

  buildUpdateHook = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";

    vendorSha256 = "1rmv3p60g6w4h4v9wx99jkyx0q02snslyjrjy9n1flardjs01b63";

    doCheck = false;
  };

  buildAPI = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-api";

    vendorSha256 = "1drrs3wrvhw8lp0877zkbx8gnbxly3fsqynww9vplajkx62z5m3a";

    doCheck = false;
  };
in buildPythonPackage rec {
  pname = "gitsrht";
  inherit version;

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    rev = version;
    sha256 = "EdxgT6IQZgj3KeU3UC+QAQb7BilBY769NhJK633tmE4=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    minio
    pygit2
    scmsrht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${buildShell "${src}/gitsrht-shell"}/bin/gitsrht-shell $out/bin/gitsrht-shell
    cp ${buildDispatcher "${src}/gitsrht-dispatch"}/bin/gitsrht-dispatch $out/bin/gitsrht-dispatch
    cp ${buildKeys "${src}/gitsrht-keys"}/bin/gitsrht-keys $out/bin/gitsrht-keys
    cp ${buildUpdateHook "${src}/gitsrht-update-hook"}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
    cp ${buildAPI "${src}/api"}/bin/api $out/bin/gitsrht-api
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
