{ lib
, fetchFromGitHub
, stdenvNoCC
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jitsi-prosody-plugins";
  version = "20240318";

  src = fetchFromGitHub {
    owner = "jitsi-contrib";
    repo = "prosody-plugins";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZApx7Z08dr1EFL5eelFG3IrfrAOpg5JqUX6hbodGwuo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    rm LICENSE README.md */README*.md
    rm -r images */docs
    cp -r * $out/

    runHook postInstall
  '';

  # nothing todo here
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  meta = with lib; {
    description = "Prosody plugins for Jitsi";
    homepage = "https://github.com/jitsi-contrib/prosody-plugins";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ janik ];
  };
})
