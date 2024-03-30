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
  version = "0.85.9";
  gqlgen = import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion = "0.17.42"; };

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    hash = "sha256-tmbBw6x3nqN9nRIR3xOXQ+L5EACXLQYLXQYK3lsOsAI=";
  };

  gitApi = buildGoModule ({
    inherit src version;
    pname = "gitsrht-api";
    modRoot = "api";
    vendorHash = "sha256-4KwnUi6ILUagMDXzuBG9CRT2N8uyjvRM74TwJqIzicc=";
  } // gqlgen);

  gitDispatch = buildGoModule ({
    inherit src version;
    pname = "gitsrht-dispatch";
    modRoot = "gitsrht-dispatch";
    vendorHash = "sha256-4KwnUi6ILUagMDXzuBG9CRT2N8uyjvRM74TwJqIzicc=";

    postPatch = ''
      substituteInPlace gitsrht-dispatch/main.go \
        --replace /var/log/gitsrht-dispatch /var/log/sourcehut/gitsrht-dispatch
    '';
  } // gqlgen);

  gitKeys = buildGoModule ({
    inherit src version;
    pname = "gitsrht-keys";
    modRoot = "gitsrht-keys";
    vendorHash = "sha256-4KwnUi6ILUagMDXzuBG9CRT2N8uyjvRM74TwJqIzicc=";

    postPatch = ''
      substituteInPlace gitsrht-keys/main.go \
        --replace /var/log/gitsrht-keys /var/log/sourcehut/gitsrht-keys
    '';
  } // gqlgen);

  gitShell = buildGoModule ({
    inherit src version;
    pname = "gitsrht-shell";
    modRoot = "gitsrht-shell";
    vendorHash = "sha256-4KwnUi6ILUagMDXzuBG9CRT2N8uyjvRM74TwJqIzicc=";

    postPatch = ''
      substituteInPlace gitsrht-shell/main.go \
        --replace /var/log/gitsrht-shell /var/log/sourcehut/gitsrht-shell
    '';
  } // gqlgen);

  gitUpdateHook = buildGoModule ({
    inherit src version;
    pname = "gitsrht-update-hook";
    modRoot = "gitsrht-update-hook";
    vendorHash = "sha256-4KwnUi6ILUagMDXzuBG9CRT2N8uyjvRM74TwJqIzicc=";

    postPatch = ''
      substituteInPlace gitsrht-update-hook/main.go \
        --replace /var/log/gitsrht-update-hook /var/log/sourcehut/gitsrht-update-hook
    '';
  } // gqlgen);
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
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
}
