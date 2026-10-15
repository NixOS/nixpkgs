{
  lib,
  symlinkJoin,
  aileron,
  vegur,
  f5_6,
  tenderness,
  medio,
  ferrum,
  seshat,
  penna,
  eunomia,
  route159,
  f1_8,
  nacelle,
  melete,
  fa_1,
}:

symlinkJoin {
  name = "dotcolon-fonts";

  paths = [
    aileron
    vegur
    f5_6
    tenderness
    medio
    ferrum
    seshat
    penna
    eunomia
    route159
    f1_8
    nacelle
    melete
    fa_1
  ];

  meta = {
    description = "Font Collection by Sora Sagano";

    homepage = "https://dotcolon.net/";

    license = with lib.licenses; [
      cc0
      ofl
    ];

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
