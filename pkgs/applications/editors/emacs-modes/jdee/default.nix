{ fetchsvn, stdenv, emacs, cedet, ant }:

let
  revision = "90";
in
  stdenv.mkDerivation rec {
    name = "jdee-svn${revision}";

    # Last release is too old, so use SVN.
    # See http://www.emacswiki.org/emacs/JavaDevelopmentEnvironment .
    src = fetchsvn {
      # Looks like they're not sure whether to put one or two `e'...
      url = "https://jdee.svn.sourceforge.net/svnroot/jdee/trunk/jde";
      rev = revision;
      sha256 = "06q1956yrs4r83a6sf3fk915jhsmg1q84wrrgjbdccfv5akid435";
    };

    patches = [
      ./installation-layout.patch ./cedet-paths.patch ./elib-avltree.patch
      ./java-directory.patch ./jde-directory-files-recurs.patch
      ./jde-help-find-javadoc.patch ./jde-wiz-update-implements-clause.patch
    ];

    configurePhase = ''
      ensureDir "dist"
      cat > build.properties <<EOF
        dist.lisp.dir = dist/share/emacs/site-lisp
        dist.java.lib.dir = dist/lib/java
        dist.jar.jde.file = dist/lib/java/jde.jar
        dist.java.src.dir = dist/src/${name}/java
        dist.doc.dir  dist/doc/${name}
        prefix.dir = $out
        cedet.dir = ${cedet}/share/emacs/site-lisp
        build.bin.emacs = ${emacs}/bin/emacs
      EOF

      # Substitute variables, à la Autoconf.
      for i in lisp/*.el
      do
        sed -i "$i" -e "s|@out@|$out|g ;
                        s|@javadir@|$out/lib/java|g ;
                        s|@datadir@|$out/share/${name}|g"
      done
    '';

    buildPhase = "ant dist";

    installPhase = ''
      ant install

      ensureDir "$out/share/${name}"
      cp -rv java/bsh-commands "$out/share/${name}"
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

      license = "GPLv2+";

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
