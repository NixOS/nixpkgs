{
  stdenv,
  fetchurl,
  pname,
  version,
  meta,
  unzip,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${finalAttrs.version}/Mailspring-AppleSilicon.zip";
    hash = "sha256-bCBQebOrkyvlzHL70RzNwVt0zJpex4pMNgDc7FQuUAU=";
  };
  dontUnpack = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    unzip $src -d $out/Applications
    makeWrapper $out/Applications/Mailspring.app/Contents/MacOS/Mailspring $out/bin/mailspring

    runHook postInstall
  '';
})
