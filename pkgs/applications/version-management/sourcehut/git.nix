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
  version = "0.78.20";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    sha256 = "sha256-rZsTtHobsgRVmMOjPa1fiKrPsNyFu/gOsmO0cTl5MqQ=";
  };

  gitApi = buildGoModule ({
    inherit src version;
    pname = "gitsrht-api";
    modRoot = "api";
    vendorHash = "sha256-cCs9FUBusaAou9w4TDOg8GKxhRcsPbSNcQpxvFH/+so=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  gitDispatch = buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatch";
    modRoot = "gitsrht-dispatch";
    vendorHash = "sha256-qWXPHo86s6iuRBhRMtmD5jxnAWKdrWHtA/iSUkdw89M=";
  };

  gitKeys = buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    modRoot = "gitsrht-keys";
    vendorHash = "sha256-9pojS69HCKVHUceyOpGtv9ewcxFD4WsOVsEzkmWJkF4=";
  };

  gitShell = buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    modRoot = "gitsrht-shell";
    vendorHash = "sha256-WqfvSPuVsOHA//86u33atMfeA11+DJhjLmWy8Ivq0NI=";
  };

  gitUpdateHook = buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    modRoot = "gitsrht-update-hook";
    vendorHash = "sha256-Bc3yPabS2S+qiroHFKrtkII/CfzBDYQ6xWxKHAME+Tc=";
  };

in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api gitsrht-dispatch gitsrht-keys gitsrht-shell gitsrht-update-hook" ""
  '';

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
