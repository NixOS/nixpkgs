{
  lib,
  trivialBuild,
  texpresso,
}:
trivialBuild {
  pname = "texpresso";
  version = texpresso.version;
  src = texpresso.src;

  preInstall = ''
    cd emacs
  '';

  meta = {
    inherit (texpresso.meta) homepage license;
    description = "Emacs mode for TeXpresso";
    maintainers = [ lib.maintainers.alexarice ];
  };
}
