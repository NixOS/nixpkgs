{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, pygit2, scmsrht }:

let
  version = "0.34.2";

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "git-sr-ht-dispatcher";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-dispatch";

    modSha256 = "1lmgmlin460g09dph2hw6yz25d4agqwjhrjv0qqsis7df9qpf3i1";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "gitsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    rev = version;
    sha256 = "1z10r2d9x71n1n36g55j4cswh0dqnzmgj2qiy1h92wwgq8azpiyy";
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
    cp ${buildDispatcher "${src}/gitsrht-dispatch"}/bin/gitsrht-dispatch $out/bin/gitsrht-dispatch
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/git.sr.ht;
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
