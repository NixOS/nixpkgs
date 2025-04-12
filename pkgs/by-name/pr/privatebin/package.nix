{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "privatebin";
  version = "1.7.5";
  src = fetchFromGitHub {
    owner = "PrivateBin";
    repo = "PrivateBin";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-LdTteUED/pq4Z4IOBttLPm3K9gx1xVqP24QQ48uvuyI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R $src/* $out
    runHook postInstall
  '';

  passthru.tests = nixosTests.privatebin;

  meta = {
    changelog = "https://github.com/PrivateBin/PrivateBin/releases/tag/${finalAttrs.version}";
    description = "Minimalist, open source online pastebin where the server has zero knowledge of pasted data.";
    homepage = "https://privatebin.info";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.savyajha ];
  };
})
