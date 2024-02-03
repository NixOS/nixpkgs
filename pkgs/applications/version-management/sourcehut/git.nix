{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, python
, srht
, scmsrht
, pygit2
, minio
, pythonOlder
, unzip
, pip
, setuptools
}:
let
  version = "0.84.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    sha256 = "sha256-sAkTsQlWtNDQ5vAhA2EeOvuJcj9A6AG8pgDyIKtr65s=";
  };

  gitApi = buildGoModule ({
    inherit src version;
    pname = "gitsrht-api";
    modRoot = "api";
    vendorHash = "sha256-LAYp0zgosZnFEbtxzjuTH9++0lbxhACr705HqXJz3D0=";
  } // import ./fix-gqlgen-trimpath.nix { inherit unzip; });

  gitDispatch = buildGoModule {
    inherit src version;
    pname = "gitsrht-dispatch";
    modRoot = "gitsrht-dispatch";
    vendorHash = "sha256-EDvSZ3/g0xDSohrsAIpNhk+F0yy8tbnTW/3tURTonMc=";

    postPatch = ''
      substituteInPlace gitsrht-dispatch/main.go \
        --replace /var/log/gitsrht-dispatch /var/log/sourcehut/gitsrht-dispatch
    '';
  };

  gitKeys = buildGoModule {
    inherit src version;
    pname = "gitsrht-keys";
    modRoot = "gitsrht-keys";
    vendorHash = "sha256-9pojS69HCKVHUceyOpGtv9ewcxFD4WsOVsEzkmWJkF4=";

    postPatch = ''
      substituteInPlace gitsrht-keys/main.go \
        --replace /var/log/gitsrht-keys /var/log/sourcehut/gitsrht-keys
    '';
  };

  gitShell = buildGoModule {
    inherit src version;
    pname = "gitsrht-shell";
    modRoot = "gitsrht-shell";
    vendorHash = "sha256-WqfvSPuVsOHA//86u33atMfeA11+DJhjLmWy8Ivq0NI=";

    postPatch = ''
      substituteInPlace gitsrht-shell/main.go \
        --replace /var/log/gitsrht-shell /var/log/sourcehut/gitsrht-shell
    '';
  };

  gitUpdateHook = buildGoModule {
    inherit src version;
    pname = "gitsrht-update-hook";
    modRoot = "gitsrht-update-hook";
    vendorHash = "sha256-Bc3yPabS2S+qiroHFKrtkII/CfzBDYQ6xWxKHAME+Tc=";

    postPatch = ''
      substituteInPlace gitsrht-update-hook/main.go \
        --replace /var/log/gitsrht-update-hook /var/log/sourcehut/gitsrht-update-hook
    '';
  };

in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";
  pyproject = true;

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api gitsrht-dispatch gitsrht-keys gitsrht-shell gitsrht-update-hook" ""
  '';

  nativeBuildInputs = [
    pip
    setuptools
  ];

  propagatedBuildInputs = [
    srht
    scmsrht
    pygit2
    minio
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
