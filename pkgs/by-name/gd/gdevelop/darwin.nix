{
  stdenvNoCC,
  fetchurl,
  unzip,

  pname,
  version,
  meta,
  passthru,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}-universal-mac.zip";
<<<<<<< HEAD
    hash = "sha256-bHpKJw/eIJt9l/wJ1qwZ3CS6TPw0RraM/YpukbOuuqo=";
=======
    hash = "sha256-F7yYZgCBMmRX1yYWC60RRtIw/ObDcbUcwY0yF4Ikagg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r "GDevelop 5.app" $out/Applications/
    runHook postInstall
  '';

})
