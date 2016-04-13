{ stdenv, pythonPackages, fetchurl }:

#
# Upstream stopped development of this package. If this package does not build
# anymore, feel free to remove it by reverting the appropriate patch
# (git log --grep bugseverywhere)
#
pythonPackages.buildPythonApplication rec {
    version = "1.1.1";
    name = "bugseverywhere-${version}";

    src = fetchurl {
      url =
      "https://pypi.python.org/packages/source/b/bugs-everywhere/bugs-everywhere-${version}.tar.gz";
      sha256 = "1ikm3ckwpimwcvx32vy7gh5gbp7q750j3327m17nvrj99g3daz2d";
    };

    # There are no tests in the repository.
    doCheck = false;

    buildInputs = with pythonPackages; [
        jinja2
        cherrypy
    ];

    meta = with stdenv.lib; {
        description = "Bugtracker supporting distributed revision control";
        homepage = "http://www.bugseverywhere.org/";
        license = licenses.gpl2Plus;
        platforms = platforms.all;
        maintainers = [ maintainers.matthiasbeyer ];
    };
}

