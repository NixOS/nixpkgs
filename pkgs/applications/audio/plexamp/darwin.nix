{
  lib,
  stdenv,
  fetchurl,
  pname,
  meta,
  version,
  undmg,
}:
stdenv.mkDerivation {
  inherit pname version;

  src =
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20241108231325/https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}-arm64.dmg";
        hash = "sha256-sXVJaL6E0VK0dNm6BBUqApD1HYwlWg+rQTkltMEK0zI=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20241108231802/https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}-x64.dmg";
        hash = "sha256-3O8xcy2hklOHKiFWzuanlq4MeCyS7DKHJysdqLoSl9Q=";
      });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ femiagbabiaka ];
  };
}
