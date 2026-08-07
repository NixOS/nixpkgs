{
  pname,
  version,
  src,
  nativeBuildInputs,
  passthru,
  meta,
  stdenv,
  undmg,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    ;

  sourceRoot = ".";

  nativeBuildInputs = nativeBuildInputs ++ [ undmg ];

  # don't break code signing
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Thunderbird*.app "$out/Applications/${passthru.applicationName}.app"

    runHook postInstall
  '';

  inherit passthru meta;
}
