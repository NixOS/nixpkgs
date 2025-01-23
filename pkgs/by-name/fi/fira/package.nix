{
  lib,
  symlinkJoin,
  fira-mono,
  fira-sans,
}:

symlinkJoin rec {
  pname = "fira";
  inherit (fira-sans) version;
  name = "${pname}-${version}";

  paths = [
    fira-mono
    fira-sans
  ];

  meta = {
    description = "Fira font family including Fira Sans and Fira Mono";
    homepage = "https://bboxtype.com/fira/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
