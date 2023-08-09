{ lib
, stdenv
, fetchurl
, undmg
, pname
, version
, meta
, ...
}:

stdenv.mkDerivation {
  inherit pname version meta;
  src =
    if stdenv.isAarch64 then
      (fetchurl
        {
          url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}-arm64.dmg";
          sha256 = "sha256-VmADu5vC2SZs930mgSw0uF69xSsPfTy/1feBYTHM55g=";
        })
    else
      (
        fetchurl
          {
            url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.dmg";
            sha256 = "sha256-gXJySo/8LwDkyR0mJNou5BD+7oxx6Crmcatf/uyMTjQ=";
          }
      );

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';
}
