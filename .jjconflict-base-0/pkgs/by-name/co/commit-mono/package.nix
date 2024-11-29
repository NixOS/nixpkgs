{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "commit-mono";
  version = "1.143";

  src = fetchzip {
    url = "https://github.com/eigilnikolajsen/commit-mono/releases/download/v${version}/CommitMono-${version}.zip";
    hash = "sha256-JTyPgWfbWq+lXQU/rgnyvPG6+V3f+FB5QUkd+I1oFKE=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;
  dontFixup = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm644 CommitMono-${version}/*.otf             -t $out/share/fonts/opentype
    install -Dm644 CommitMono-${version}/ttfautohint/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    description = "Anonymous and neutral programming typeface focused on creating a better reading experience";
    homepage = "https://commitmono.com/";
    license = licenses.ofl;
    maintainers = [ maintainers.yoavlavi ];
    platforms = platforms.all;
  };
}
