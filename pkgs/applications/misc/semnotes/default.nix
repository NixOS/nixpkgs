{ stdenv, fetchurl, cmake, qt4, kdelibs, soprano, automoc4, phonon, shared_desktop_ontologies }:
stdenv.mkDerivation {
  name = "semnotes-0.4.0-1";

  src = fetchurl {
    url = "mirror://sourceforge/semn/0.4.0/semnotes-0.4.0-1-src.tar.bz2";
    sha256 = "1zh5jfh7pyhyz5fbzcgzyckdg0ny7sf8s16yy6rjw9n021zz5i7m";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon soprano shared_desktop_ontologies ];

  meta = with stdenv.lib; {
    description = "Semantic note-taking tool for KDE based on Nepomuk-KDE";
    longDescription = ''
      SemNotes links notes to the data that is available on the user's desktop.
      The data stored about a note consists of: a title, content, tags, creation
      and last modification time. The notes and all the information about them
      are stored as RDF resources in the Nepomuk repository. They are
      automatically linked to the resources they reference.
    '';
    license = "GPL";
    homepage = http://smile.deri.ie/projects/semn;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}