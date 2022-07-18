{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, mednafen
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mednaffe";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = version;
    sha256 = "sha256-zvSAt6CMcgdoPpTTA5sPlQaWUw9LUMsR2Xg9jM2UaWY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 mednafen ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH ':' "${mednafen}/bin"
    )
   '';

  meta = with lib; {
    description = "GTK-based frontend for mednafen emulator";
    homepage = "https://github.com/AmatCoder/mednaffe";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sheenobu yana AndersonTorres ];
    platforms = platforms.unix;
  };
}
