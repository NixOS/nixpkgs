{
  lib,
  melpaBuild,
  texpresso,
}:
melpaBuild {
  pname = "texpresso";
  inherit (texpresso) version;
  inherit (texpresso) src;

  files = ''("emacs/*.el")'';

  meta = {
    inherit (texpresso.meta) homepage license;
    description = "Emacs mode for TeXpresso";
    maintainers = [ lib.maintainers.alexarice ];
  };
}
