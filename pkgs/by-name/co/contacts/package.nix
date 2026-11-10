{
  lib,
  stdenv,
  fetchFromGitHub,
  xcbuildHook,
}:

stdenv.mkDerivation {
  version = "1.1a-3";
  pname = "contacts";

  src = fetchFromGitHub {
    owner = "dhess";
    repo = "contacts";
    rev = "4092a3c6615d7a22852a3bafc44e4aeeb698aa8f";
    hash = "sha256-Li/c5uf9rfpuU+hduuSm7EmhVwIIkS72dqzmN+0cE3A=";
  };

  postPatch = ''
    substituteInPlace contacts.m \
      --replace "int peopleSort" "long peopleSort"
  '';

  nativeBuildInputs = [ xcbuildHook ];

  installPhase = ''
    mkdir -p $out/bin
    cp Products/Default/contacts $out/bin
  '';

  meta = {
    description = "Access contacts from the Mac address book from command-line";
    homepage = "http://www.gnufoo.org/contacts/contacts.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jwiegley ];
    platforms = lib.platforms.darwin;
    hydraPlatforms = lib.platforms.darwin;
  };
}
