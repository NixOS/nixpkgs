{
  lib,
  stdenv,
  crystal,
  fetchFromGitHub,
  # https://crystal-lang.org/2019/09/06/parallelism-in-crystal/
  multithreading ? true,
  static ? stdenv.hostPlatform.isStatic,
}:

crystal.buildCrystalPackage rec {
  pname = "blahaj";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "BLAHAJ";
    rev = "v${version}";
    hash = "sha256-CmMF9jDKUo+c8dYc2UEHKdBDE4dgwExcRS5sSUsUJik=";
  };

  buildTargets = [ "${if static then "static" else "build"}${if multithreading then "_mt" else ""}" ];

  meta = with lib; {
    description = "Gay sharks at your local terminal - lolcat-like CLI tool";
    homepage = "https://blahaj.queer.software";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      aleksana
      cafkafk
    ];
    mainProgram = "blahaj";
  };
}
