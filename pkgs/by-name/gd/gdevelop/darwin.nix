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
    hash = "sha256-XSDzvh8zjrmKOP7YXjXG5+3qCzGQEJp1+RmwmRd4oOs=";
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
