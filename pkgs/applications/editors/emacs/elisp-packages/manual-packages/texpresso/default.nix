{
  lib,
  melpaBuild,
  texpresso,
}:
melpaBuild {
  pname = "texpresso";
  version = texpresso.version;
  src = texpresso.src;

  files = ''("emacs/*.el")'';

  ignoreCompilationError = false;

  meta = {
    inherit (texpresso.meta) homepage license;
    description = "Emacs mode for TeXpresso";
    maintainers = [ lib.maintainers.alexarice ];
  };
}
