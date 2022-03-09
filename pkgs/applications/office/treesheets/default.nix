{ lib, stdenv, fetchFromGitHub, wxGTK, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "treesheets";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "aardappel";
    repo   = "treesheets";
    rev    = "v${version}";
    sha256 = "0krsj7i5yr76imf83krz2lmlmpbsvpwqg2d4r0jwxiydjfyj4qr4";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wxGTK ];

  preConfigure = "cd src";

  postInstall = ''
    mkdir -p "$out/libexec"
    cp -av ../TS "$out/libexec/treesheets"

    mkdir -p "$out/bin"
    makeWrapper "$out/libexec/treesheets/treesheets" "$out/bin/treesheets"

    mkdir -p "$out/share/doc/treesheets"

    for f in readme.html docs examples
    do
      mv -v "$out/libexec/treesheets/$f" "$out/share/doc/treesheets"
      ln -sv "$out/share/doc/treesheets/$f" "$out/libexec/treesheets/$f"
    done

    mkdir "$out/share/applications" -p
    mv -v "$out/libexec/treesheets/treesheets.desktop" "$out/share/applications"
    substituteInPlace "$out/share/applications/treesheets.desktop" \
      --replace "Icon=images/treesheets.svg" "Icon=$out/libexec/treesheets/images/treesheets.svg"
  '';

  meta = with lib; {
    description = "Free Form Data Organizer";

    longDescription = ''
      The ultimate replacement for spreadsheets, mind mappers, outliners,
      PIMs, text editors and small databases.

      Suitable for any kind of data organization, such as Todo lists,
      calendars, project management, brainstorming, organizing ideas,
      planning, requirements gathering, presentation of information, etc.
    '';

    homepage    = "https://strlen.com/treesheets/";
    maintainers = with maintainers; [ obadz avery ];
    platforms   = platforms.linux;
    license     = licenses.zlib;
  };
}
