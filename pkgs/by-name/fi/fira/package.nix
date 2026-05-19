{
  lib,
  symlinkJoin,
  fira-mono,
  fira-sans,
}:

symlinkJoin {
  pname = "fira";
  inherit (fira-sans) version;

  paths = [
    fira-mono
    fira-sans
  ];

  meta = {
    description = "Font family including Fira Sans and Fira Mono";
    homepage = "https://carrois.com/fira/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
