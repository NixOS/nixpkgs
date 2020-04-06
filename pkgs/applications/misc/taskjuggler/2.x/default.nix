{stdenv, fetchurl,
zlib, libpng, libjpeg, perl, expat, qt3,
libX11, libXext, libSM, libICE,
}:

stdenv.mkDerivation rec {
  name = "taskjuggler-2.4.3";
  src = fetchurl {
    url = "http://www.taskjuggler.org/download/${name}.tar.bz2";
    sha256 = "14gkxa2vwfih5z7fffbavps7m44z5bq950qndigw2icam5ks83jl";
  };

  buildInputs =
    [zlib libpng libX11 libXext libSM libICE perl expat libjpeg]
    ;

  patches = [ ./timezone-glibc.patch ];

  preConfigure = ''
    for i in $(grep -R "/bin/bash" .  | sed 's/:.*//'); do
      substituteInPlace $i --replace /bin/bash $(type -Pp bash)
    done
    for i in $(grep -R "/usr/bin/perl" .  | sed 's/:.*//'); do
      substituteInPlace $i --replace /usr/bin/perl ${perl}/bin/perl
    done

    # Fix install
    for i in docs/en/Makefile.in Examples/BigProject/Common/Makefile.in Examples/BigProject/Makefile.in Examples/BigProject/Project1/Makefile.in Examples/BigProject/Project2/Makefile.in Examples/FirstProject/Makefile.in Examples/ShiftSchedule/Makefile.in; do
      # Do not use variable substitution because there is some text after the last '@'
      substituteInPlace $i --replace 'docprefix = @PACKAGES_DIR@' 'docprefix = $(docdir)/'
    done

    # Comment because the ical export need the KDE support.
    for i in Examples/FirstProject/AccountingSoftware.tjp; do
      substituteInPlace $i --replace "icalreport" "# icalreport"
    done

    for i in TestSuite/testdir TestSuite/createrefs \
      TestSuite/Scheduler/Correct/Expression.sh; do
      substituteInPlace $i --replace '/bin/rm' 'rm'
    done

    # Some tests require writing at $HOME
    HOME=$TMPDIR
  '';

  configureFlags = [
    "--without-arts" "--disable-docs"
    "--x-includes=${libX11.dev}/include"
    "--x-libraries=${libX11.out}/lib"
    "--with-qt-dir=${qt3}"
  ];

  preInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp Contrib/emacs/taskjug.el $out/share/emacs/site-lisp/
  '';

  # kde_locale is not defined when installing without kde.
  installFlags = [ "kde_locale=\${out}/share/locale" ];

  meta = {
    homepage = http://www.taskjuggler.org;
    license = stdenv.lib.licenses.gpl2;
    description = "Project management tool";
    longDescription = ''
      TaskJuggler is a modern and powerful, Open Source project management
      tool. Its new approach to project planing and tracking is more
      flexible and superior to the commonly used Gantt chart editing
      tools. It has already been successfully used in many projects and
      scales easily to projects with hundreds of resources and thousands of
      tasks.
    '';
  };
}
