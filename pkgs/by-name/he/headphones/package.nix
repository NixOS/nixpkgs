{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "headphones";
  version = "0.6.4";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${finalAttrs.version}";
    sha256 = "0gv7rasjbm4rf9izghibgf5fbjykvzv0ibqc2in1naagjivqrpq4";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/headphones
    cp -R {data,headphones,lib,Headphones.py} $out/opt/headphones

    echo v${finalAttrs.version} > $out/opt/headphones/version.txt

    makeWrapper $out/opt/headphones/Headphones.py $out/bin/headphones

    runHook postInstall
  '';

  meta = {
    description = "Automatic music downloader for SABnzbd";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/rembo10/headphones";
    maintainers = with lib.maintainers; [ rembo10 ];
    mainProgram = "headphones";
  };
})
