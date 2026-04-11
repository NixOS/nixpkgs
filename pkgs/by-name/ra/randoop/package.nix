{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.3.4";
  pname = "randoop";

  src = fetchurl {
    url = "https://github.com/randoop/randoop/releases/download/v${finalAttrs.version}/randoop-${finalAttrs.version}.zip";
    sha256 = "sha256-yzQw9l3uAq51SHXJ4rsZNRCiFdhOEoSrwv9iPvD2i9c=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib $out/doc

    cp -R *.jar $out/lib
    cp README.txt $out/doc
  '';

  meta = {
    description = "Automatic test generation for Java";
    homepage = "https://randoop.github.io/randoop/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
