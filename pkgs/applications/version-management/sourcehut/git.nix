{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, python
, srht
, pygit2
, scmsrht
, unzip
}:
let
  version = "0.78.18";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    sha256 = "sha256-pGWphdFKaOIBIKWMxfNAFqXZQx/qHcrwb5Ylj9uag7s=";
  };

  gitApi = buildGoModule ({
    inherit src version;
    pname = "gitsrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-0YI20liP0X1McfiSUy29zJk2UqqAPBIfIfPLoJOE1uI=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

  gitDispatch = buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatch";
    modRoot = "gitsrht-dispatch";
    vendorSha256 = "sha256-qWXPHo86s6iuRBhRMtmD5jxnAWKdrWHtA/iSUkdw89M=";
  };

  gitKeys = buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    modRoot = "gitsrht-keys";
    vendorSha256 = "sha256-9pojS69HCKVHUceyOpGtv9ewcxFD4WsOVsEzkmWJkF4=";
  };

  gitShell = buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    modRoot = "gitsrht-shell";
    vendorSha256 = "sha256-WqfvSPuVsOHA//86u33atMfeA11+DJhjLmWy8Ivq0NI=";
  };

  gitUpdateHook = buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    modRoot = "gitsrht-update-hook";
    vendorSha256 = "sha256-Bc3yPabS2S+qiroHFKrtkII/CfzBDYQ6xWxKHAME+Tc=";
  };

in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";

  patches = [
    # Revert change breaking Unix socket support for Redis
    patches/redis-socket/git/0001-Revert-Add-webhook-queue-monitoring.patch
  ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api gitsrht-dispatch gitsrht-keys gitsrht-shell gitsrht-update-hook" ""
  '';

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
    ln -s ${gitApi}/bin/api $out/bin/gitsrht-api
    ln -s ${gitDispatch}/bin/gitsrht-dispatch $out/bin/gitsrht-dispatch
    ln -s ${gitKeys}/bin/gitsrht-keys $out/bin/gitsrht-keys
    ln -s ${gitShell}/bin/gitsrht-shell $out/bin/gitsrht-shell
    ln -s ${gitUpdateHook}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
  '';

  pythonImportsCheck = [ "gitsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
