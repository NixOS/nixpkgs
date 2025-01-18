{
  fetchFromGitHub,
  lib,
  makeWrapper,
  python3,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "my-b-bscan";
  version = "3.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "0xB9";
    repo = "MyBBscan";
    tag = "v${version}";
    hash = "sha256-cX1483JK+bejQWua9d7V3GDw6cPPvlnLX5w2XQjqMOQ=";
  };

  build-system = [ makeWrapper ];

  dependencies = with python3Packages; [
    huepy
    requests
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/mybbscan}
    cp -R * $out/share/mybbscan
    makeWrapper ${python3.interpreter} $out/bin/mybbscan \
      --set PYTHONPATH "$PYTHONPATH:$out/share/mybbscan/scan.py" \
      --add-flags "$out/share/mybbscan/scan.py"
  '';

  meta = with lib; {
    description = "Scans plugins directory for possible vulnerable plugins";
    homepage = "https://github.com/0xB9/MyBBscan";
    # https://github.com/0xB9/MyBBscan/issues/12
    license = licenses.unfree;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "mybbscan";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.all;
  };
}
