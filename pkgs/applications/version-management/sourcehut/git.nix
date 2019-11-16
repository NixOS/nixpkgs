{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, pygit2, scmsrht }:

let
  version = "0.35.6";

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "git-srht-shell";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-shell";

    modSha256 = "1v4npijqgv09ssrxf1y1b3syb2fs7smy7k9rcj3ynsfrn9xgfd9y";
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "git-srht-dispatcher";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-dispatch";

    modSha256 = "1lmgmlin460g09dph2hw6yz25d4agqwjhrjv0qqsis7df9qpf3i1";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "gitsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    rev = version;
    sha256 = "0j8caqbzdqkgc1bdhzz4k5hgh8lhsghfgwf46d19ryf83d8ggxqc";
  };

  patches = [
    ./use-srht-path.patch
  ];

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
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
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/git.sr.ht;
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
