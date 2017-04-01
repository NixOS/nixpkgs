{ stdenv, fetchFromGitHub, wxGTK, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "treesheets-${version}";
  version = "2017-03-27";

  src = fetchFromGitHub {
    owner  = "aardappel";
    repo   = "treesheets";
    rev    = "1d1d6b214e3ae88445eb1ec0032d5fef14160f32";
    sha256 = "0np91c4skq3yxq76c4zi33w73qb1w2nrcin490kkvrxk53jspklb";
  };

  buildInputs = [ wxGTK makeWrapper ];

  preConfigure = "cd src";

  postInstall = ''
    mkdir "$out/share" -p
    cp -av ../TS "$out/share/libexec"

    mkdir "$out/bin" -p
    makeWrapper "$out/share/libexec/treesheets" "$out/bin/treesheets"

    mkdir "$out/share/doc" -p

    for f in readme.html docs examples
    do
      mv -v "$out/share/libexec/$f" "$out/share/doc"
      ln -sv "$out/share/doc/$f" "$out/share/libexec/$f"
    done

    mkdir "$out/share/applications" -p
    mv -v "$out/share/libexec/treesheets.desktop" "$out/share/applications"
    substituteInPlace "$out/share/applications/treesheets.desktop" \
      --replace "Icon=images/treesheets.svg" "Icon=$out/share/libexec/images/treesheets.svg"
  '';

  meta = with stdenv.lib; {
    description = "Free Form Data Organizer";

    longDescription = ''
      The ultimate replacement for spreadsheets, mind mappers, outliners,
      PIMs, text editors and small databases.

      Suitable for any kind of data organization, such as Todo lists,
      calendars, project management, brainstorming, organizing ideas,
      planning, requirements gathering, presentation of information, etc.
    '';

    homepage    = http://strlen.com/treesheets/;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
    license     = licenses.zlib;
  };
}
