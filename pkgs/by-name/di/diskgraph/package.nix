{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "diskgraph";
  version = "0-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "stolk";
    repo = "diskgraph";
    rev = "9a515fc620a792d118763ea591c304792e511274";
    hash = "sha256-iL4u63/dGapOSK7AuV1FChDUcwsBOcx0TYAhcH9E+S0=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Terminal-based monitor for disk I/O";
    homepage = "https://github.com/stolk/diskgraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fliegendewurst
      nettika
    ];
    mainProgram = "diskgraph";
    platforms = lib.platforms.linux;
  };
}
