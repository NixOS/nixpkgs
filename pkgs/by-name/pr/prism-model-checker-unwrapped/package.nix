{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  java,
  cctools,
}:
stdenv.mkDerivation rec {
  pname = "prism-model-checker-unwrapped";
  version = "4.8.1";

  dirname = "prism-model-checker${version}";

  src = fetchFromGitHub {
    owner = "prismmodelchecker";
    repo = "prism";
    rev = "v4.8.1";
    sha256 = "sha256-igFRIjPfx0BFpQjaW/vgMEnH2HLC06aL3IMHh+ELB6U=";
  };

  nativeBuildInputs = [ java ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  postPatch = ''
    sed -i "s/\/bin\/mv/mv/" prism/install.sh
  '';

  makeFlags = [ "JAVA_DIR=${java}" ];
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
