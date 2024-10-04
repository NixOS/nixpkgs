{ lib, stdenv, coreutils, fetchFromGitHub, java }:
stdenv.mkDerivation rec {
  pname = "prism-model-checker-unwrapped";
  version = "4.7";

  dirname = "prism-model-checker${version}";

  src = fetchFromGitHub {
    owner = "prismmodelchecker";
    repo = "prism";
    rev = "v4.7";
    sha256 = "sha256-ivZshLRtje9B+8RiG0jhGX8YkLvMCz62+I25ycR5dQs=";
  };

  nativeBuildInputs = [java];

  postPatch = ''
    sed -i "s/\/bin\/mv/mv/" prism/install.sh
    '';

  makeFlags = ["JAVA_DIR=${java}"];
  preBuild = ''
    cd prism
    '';

  installPhase = ''
    mkdir --parents $out
    cp -r bin/ $out/
    cp -r lib/ $out/
    cp -r include/ $out/
    cp -r ext/ $out/
    cp -r etc/ $out/
    cp -r images/ $out/
    cp -r dtds/ $out/
    cp -r classes/ $out/
    mv install.sh $out/
    cd $out
    ./install.sh
    rm install.sh
    '';

  meta = with lib; {
    description = "A Probabalistic Symbolic Model Checker";

    homepage = "https://www.prismmodelchecker.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.astrobeastie ];
    platforms = platforms.unix;
  };
}

