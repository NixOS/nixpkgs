{ fetchsvn, stdenv, emacs, cedet, ant }:

let
  revision = "137";
in
  stdenv.mkDerivation rec {
    name = "jdee-svn${revision}";

    # Last release is too old, so use SVN.
    # See http://www.emacswiki.org/emacs/JavaDevelopmentEnvironment .
    src = fetchsvn {
      url = "https://jdee.svn.sourceforge.net/svnroot/jdee/trunk/jdee";
      rev = revision;
      sha256 = "1z1y957glbqm7z3dhah9h4jysw3173pq1gpx5agfwcw614n516xz";
    };

    patchFlags = "-p1 --ignore-whitespace";

    patches = [
      ./build-properties.patch
      ./cedet-paths.patch ./elib-avltree.patch
      ./java-directory.patch
    ];

    configurePhase = ''
      mkdir -p "dist"
      cat > build.properties <<EOF
        dist.lisp.dir = dist/share/emacs/site-lisp
        dist.java.lib.dir = dist/share/java
        dist.jar.jde.file = dist/share/java/jde.jar
        dist.java.src.dir = dist/src/${name}/java
        dist.doc.dir  dist/doc/${name}
        prefix.dir = $out
        cedet.dir = ${cedet}/share/emacs/site-lisp
        elib.dir = /nowhere
        build.bin.emacs = ${emacs}/bin/emacs
      EOF

      # Substitute variables, à la Autoconf.
      for i in "lisp/"*.el
      do
        sed -i "$i" -e "s|@out@|$out|g ;
                        s|@javadir@|$out/share/java|g ;
                        s|@datadir@|$out/share/${name}|g"
      done
    '';

    buildPhase = "ant dist";

    installPhase = ''
      ant install

      mkdir -p "$out/share/${name}"
      cp -rv java/bsh-commands "$out/share/${name}"

      # Move everything that's not a JAR to $datadir.  This includes
      # `sun_checks.xml', license files, etc.
      cd "$out/share/java"
      for i in *
      do
        if echo $i | grep -qv '\.jar''$'
        then
            mv -v "$i" "$out/share/${name}"
        fi
      done
    '';

    buildInputs = [ emacs ant ];
    propagatedBuildInputs = [ cedet ];
    propagatedUserEnvPkgs = propagatedBuildInputs; # FIXME: Not honored

    meta = {
      description = "JDEE, a Java development environment for Emacs";

      longDescription = ''
        The JDEE is a software package that interfaces Emacs to
        command-line Java development tools (for example, JavaSoft's
        JDK).  JDEE features include:

        * JDEE menu with compile, run, debug, build, browse, project,
          and help commands
        * syntax coloring
        * auto indentation
        * compile error to source links
        * source-level debugging
        * source code browsing
        * make file support
        * automatic code generation
        * Java source interpreter (Pat Neimeyer's BeanShell)
      '';

      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
      platforms = stdenv.lib.platforms.gnu;  # arbitrary choice

      broken = true;
    };
  }
