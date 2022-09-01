{ lib, stdenvNoCC, fetchFromGitHub, python3 }:

stdenvNoCC.mkDerivation rec {
  name = "ovmfvartool";
  version = "unstable-2021-06-16";

  src = fetchFromGitHub {
    owner = "hlandau";
    repo = name;
    rev = "c4c0c24dce1d201f95dfd69fd7fd9d51ea301377";
    hash = "sha256-3OvYAB41apPn1c2YTKBIEITmHSUMQ0oEijY5DhZWWGo=";
  };

  postPatch = let
    pythonPkg = python3.withPackages (p: with p; [ pyyaml ]);
  in ''
    # needed in build but /usr/bin/env is not available in sandbox
    substituteInPlace ovmfvartool \
      --replace "/usr/bin/env python3" "${pythonPkg.interpreter}"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ovmfvartool $out/bin/
  '';

  meta = with lib; {
    description = "Parse and generate OVMF_VARS.fd from Yaml";
    homepage = "https://github.com/hlandau/ovmfvartool";
    license = licenses.gpl3;
    maintainers = with maintainers; [ baloo raitobezarius ];
  };
}
