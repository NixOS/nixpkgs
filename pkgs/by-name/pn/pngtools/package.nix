{
  lib,
  stdenv,
  libpng12,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "pngtools";
  version = "0-unstable-2022-03-14";

  src = fetchFromGitHub {
    owner = "mikalstill";
    repo = "pngtools";
    rev = "1ccca3a0f3f6882661bbafbfb62feb774ca195d1";
    sha256 = "sha256-W1XofOVTyfA7IbxOnTkWdOOZ00gZ4e0GOYl7nMtLIJk=";
  };

  buildInputs = [ libpng12 ];

  meta = with lib; {
    homepage = "https://github.com/mikalstill/pngtools";
    description = "PNG manipulation tools";
    maintainers = with maintainers; [ zendo ];
    license = licenses.gpl2Only;
    platforms = platforms.all;
  };
}
