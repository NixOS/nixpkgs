{
  stdenv,
  fetchurl,
  undmg,
  pname,
  version,
}:

stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "https://download.zotero.org/client/release/${version}/Zotero-${version}.dmg";
    sha256 = "sha256-5AhOUCCL1/JUEXuPC9lkjNAHRPjiCqOV9nPb7eU+YdI=";
  };

  dontBuild = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
}
