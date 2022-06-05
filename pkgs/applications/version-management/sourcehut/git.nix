{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, python
, srht
, pygit2
, scmsrht
}:
let
  version = "0.77.3";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    sha256 = "sha256-eJvXCcmdiUzTK0EqNJkLEZsAfr6toD/378HObnMbOWM=";
  };

  buildShell = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    vendorSha256 = "sha256-aqUFICp0C2reqb2p6JCPAUIRsxzSv0t9BHoNWrTYfqk=";
  };

  buildDispatcher = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatcher";
    vendorSha256 = "sha256-qWXPHo86s6iuRBhRMtmD5jxnAWKdrWHtA/iSUkdw89M=";
  };

  buildKeys = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    vendorSha256 = "sha256-9pojS69HCKVHUceyOpGtv9ewcxFD4WsOVsEzkmWJkF4=";
  };

  buildUpdateHook = src: buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    vendorSha256 = "sha256-sBlG7EFqdDm7CkAHVX50Mf4N3sl1rPNmWExG/bfbfGA=";
  };

  updateHook = buildUpdateHook "${src}/gitsrht-update-hook";

in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/git/0001-Revert-Add-webhook-queue-monitoring.patch
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
    cp ${updateHook}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
  '';
  passthru = {
    inherit updateHook;
  };

  pythonImportsCheck = [ "gitsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
