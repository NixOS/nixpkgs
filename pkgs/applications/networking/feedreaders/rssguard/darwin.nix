{
  pname,
  version,
  meta,
  stdenv,
  fetchurl,
  undmg,
}:

stdenv.mkDerivation rec {
  inherit
    pname
    version
    meta
    ;

  gitSha = "3dde4064f";
  src = fetchurl {
    url = "https://github.com/martinrotter/rssguard/releases/download/${version}/rssguard-${version}-${gitSha}-mac64.dmg";
    hash = "sha256-0mizWy1mzpbH5lRCRni34WQNqGu/J7XUYv6P5MbRiIw=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true; # breaks notarization

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r 'RSS Guard.app' $out/Applications

    runHook postInstall
  '';
}
