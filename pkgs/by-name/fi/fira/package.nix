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

  meta = with lib; {
    description = "Fira font family including Fira Sans and Fira Mono";
    homepage = "https://bboxtype.com/fira/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
