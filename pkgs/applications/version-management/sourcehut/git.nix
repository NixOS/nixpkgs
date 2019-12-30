{ stdenv, fetchgit, buildPythonPackage
, python
, buildGoModule
, srht, pygit2, scmsrht }:

let
  version = "0.43.3";

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-shell";

    modSha256 = "0lxxxzh39bviab71kfsqqr217338yxn5l2zkak55r6qqs6iz4ccv";
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatcher";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-dispatch";

    modSha256 = "1lmgmlin460g09dph2hw6yz25d4agqwjhrjv0qqsis7df9qpf3i1";
  };

  buildKeys = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-keys";

    modSha256 = "1pfcw9n63zhlxm9kd3bxa2zqmzd8mgl7yl2ck055j56v3k929w3f";
  };

  buildUpdateHook = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    goPackagePath = "git.sr.ht/~sircmpwn/git.sr.ht/gitsrht-update-hook";

    modSha256 = "0p8qd6hpgmnlfqk5vw6l41dqs7qjhf6xijzj5iv6wv1cf362b4wp";
  };
in buildPythonPackage rec {
  inherit version;
  pname = "gitsrht";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    rev = version;
    sha256 = "1f9wfyri85bq4zi9xkbfcfb69q4abh0hz7p3lghj460hh9zxc57w";
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
    cp ${buildKeys "${src}/gitsrht-keys"}/bin/gitsrht-keys $out/bin/gitsrht-keys
    cp ${buildUpdateHook "${src}/gitsrht-update-hook"}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/git.sr.ht;
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
