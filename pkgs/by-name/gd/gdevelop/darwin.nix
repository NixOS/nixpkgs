{
  stdenvNoCC,
  fetchurl,
  unzip,

  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}-universal-mac.zip";
    hash = "sha256-0FT4JHGJKy6UapuV2tXKzWm0Esr6DPqu38PllUbUtrY=";
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
