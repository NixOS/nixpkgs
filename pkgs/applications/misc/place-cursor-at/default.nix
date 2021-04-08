{ stdenv
, fetchFromGitHub
, haskellPackages
, libXinerama
}:
let inherit (haskellPackages) base base-unicode-symbols X11; in
haskellPackages.mkDerivation rec {
  pname = "place-cursor-at";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "unclechu";
    repo = "place-cursor-at";
    rev = "v${version}";
    sha256 = "1kryqcjnj33v6dva8nfb46qjw7ar9x7lhrns1ncns53xy2mdl9f0";
  };

  isExecutable = true;
  isLibrary = false;
  enableSharedExecutables = false;
  enableLibraryProfiling = false;
  doHaddock = false;
  postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";

  executableHaskellDepends = [ base base-unicode-symbols X11 ];
  executableSystemDepends = [ libXinerama ];
  homepage = "https://github.com/unclechu/place-cursor-at#readme";
  description = "A utility for X11 that moves the mouse cursor using the keyboard";
  license = stdenv.lib.licenses.gpl3;
}
