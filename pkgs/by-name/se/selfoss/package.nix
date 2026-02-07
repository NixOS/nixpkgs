{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "selfoss";
  version = "2.19";

  src = fetchurl {
    url = "https://github.com/SSilence/selfoss/releases/download/${finalAttrs.version}/selfoss-${finalAttrs.version}.zip";
    sha256 = "5JxHUOlyMneWPKaZtgLwn5FI4rnyWPzmsUQpSYrw5Pw=";
  };

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    cp -ra \
      .htaccess \
      .nginx.conf \
      * \
      "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Web-based news feed (RSS/Atom) aggregator";
    homepage = "https://selfoss.aditu.de";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jtojnar
      regnat
    ];
    platforms = lib.platforms.all;
  };
})
