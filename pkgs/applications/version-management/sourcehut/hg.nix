{ lib
, fetchhg
, buildGoModule
, buildPythonPackage
, srht
, hglib
, scmsrht
, unidiff
, python
, unzip
}:

buildPythonPackage rec {
  pname = "hgsrht";
  version = "0.31.2";

  src = fetchhg {
    url = "https://hg.sr.ht/~sircmpwn/hg.sr.ht";
    rev = version;
    sha256 = "F0dBykSSrlis+mumULLxvKNxD75DWR9+IDTYbmhkMDI=";
  };
  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: api hgsrht-keys" ""
  '';

  hgsrht-api = buildGoModule ({
    inherit src version;
    pname = "hgsrht-api";
    modRoot = "api";
    vendorSha256 = "sha256-W7A22qSIgJgcfS7xYNrmbYKaZBXbDtPilM9I6DxmTeU=";
  } // import ./fix-gqlgen-trimpath.nix {inherit unzip;});

  hgsrht-keys = buildGoModule {
    inherit src version;
    pname = "hgsrht-keys";
    modRoot = "hgsrht-keys";
    vendorSha256 = "sha256-7ti8xCjSrxsslF7/1X/GY4FDl+69hPL4UwCDfjxmJLU=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    hglib
    scmsrht
    unidiff
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    ln -s ${hgsrht-api}/bin/api $out/bin/hgsrht-api
    ln -s ${hgsrht-keys}/bin/hgsrht-keys $out/bin/hgsrht-keys
  '';

  pythonImportsCheck = [ "hgsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hg.sr.ht";
    description = "Mercurial repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
