{
  lib,
  stdenv,
  got-unwrapped,
  openssh,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "got";
  inherit (got-unwrapped) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${got-unwrapped}/bin/got $out/bin/got \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}

    runHook postInstall
  '';

  meta = {
    inherit (got-unwrapped.meta)
      changelog
      description
      longDescription
      homepage
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
