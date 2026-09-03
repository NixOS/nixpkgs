{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  python3,
}:

ocamlPackages.buildDunePackage rec {
  pname = "herdtools7";
  version = "7.58";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herd";
    repo = "herdtools7";
    rev = version;
    hash = "sha256-0+tyzuEPji/mCsN6ez4C+iJz5IroV3zAjVsbgG6lPJo=";
  };

  nativeBuildInputs = [
    python3
    ocamlPackages.menhir
  ];

  propagatedBuildInputs = with ocamlPackages; [
    menhirLib
    zarith
  ];

  env = {
    DUNE_CACHE = "disabled";
  };

  preBuild = ''
    ./version-gen.sh $out
  '';

  postInstall = ''
    mkdir -p $out/share/herdtools7
    cp -r herd/libdir $out/share/herdtools7/herd
    cp -r litmus/libdir $out/share/herdtools7/litmus
    cp -r jingle/libdir $out/share/herdtools7/jingle
  '';

  meta = {
    homepage = "https://github.com/herd/herdtools7";
    description = "The Herd toolsuite to deal with .cat memory models";
    license = lib.licenses.cecill-b;
    maintainers = with lib.maintainers; [ garyguo ];
  };
}
