{
  stdenv,
  undmg,
  pname,
  version,
  src,
  meta,
  ...
}:
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Keymapp.app $out/Applications

    runHook postInstall
  '';
}
