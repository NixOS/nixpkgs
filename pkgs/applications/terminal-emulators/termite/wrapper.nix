{
  makeWrapper,
  symlinkJoin,
  configFile ? null,
  termite,
}:

if configFile == null then
  termite
else
  symlinkJoin {
    name = "termite-with-config-${termite.version}";

    paths = [ termite ];
    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/termite \
        --add-flags "--config ${configFile}"
    '';

    passthru.terminfo = termite.terminfo;
  }
