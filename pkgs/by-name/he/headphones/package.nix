{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "headphones";
  version = "0.6.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "rembo10";
    repo = "headphones";
    rev = "v${version}";
    sha256 = "0gv7rasjbm4rf9izghibgf5fbjykvzv0ibqc2in1naagjivqrpq4";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/headphones
    cp -R {data,headphones,lib,Headphones.py} $out/opt/headphones

    echo v${version} > $out/opt/headphones/version.txt

    makeWrapper $out/opt/headphones/Headphones.py $out/bin/headphones

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Automatic music downloader for SABnzbd";
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "Automatic music downloader for SABnzbd";
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/rembo10/headphones";
    maintainers = with lib.maintainers; [ rembo10 ];
    mainProgram = "headphones";
  };
}
