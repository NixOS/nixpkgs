{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, minio, pygit2, scmsrht }:

let
  version = "0.60.7";

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    vendorSha256 = "1abyv2s5l3bs0iylpgyj3jri2hh1iy8fiadxm7g6l2vl58h0b9ba";
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatcher";
    vendorSha256 = "1lzkf13m54pq0gnn3bcxc80nfg76hgck4l8q8jpaicrsiwgcyrd9";
  };

  buildKeys = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    vendorSha256 = "0lks3js57bb41x1ry5xfadlzf0v2gm68g7h3j94gzlm6j4jfprk9";
  };

  buildUpdateHook = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    vendorSha256 = "06ykh9ncamd922xsd329jpn293wsq6vkqnlf3sckjlp2hm290pd8";
  };

  buildAPI = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-api";
    vendorSha256 = "0d6kmsbsgj2q5nddx4w675zbsiarffj9vqplwvqk7dwz4id2wnif";
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
