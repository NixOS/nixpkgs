{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "osx-cpu-temp";
  version = "unstable-2020-12-04";

  src = fetchFromGitHub {
    name = "osx-cpu-temp-source";
    owner = "lavoiesl";
    repo = "osx-cpu-temp";
    rev = "6ec951be449badcb7fb84676bbc2c521e600e844";
    hash = "sha256-Lb2l3RjQA570WdTtQUbaP0kHLsMbubaksfSuUvJbkdo=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp osx-cpu-temp $out/bin
  '';

  meta = {
    description = "Outputs current CPU temperature for OSX";
    homepage = "https://github.com/lavoiesl/osx-cpu-temp";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ virusdave ];
    platforms = lib.platforms.darwin;
  };
}
