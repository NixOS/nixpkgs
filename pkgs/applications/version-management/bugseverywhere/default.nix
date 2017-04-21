{ stdenv, python2Packages, fetchurl }:

#
# Note that there is a github mirror at
# https://github.com/aaiyer/bugseverywhere/
# which is ahead of this very package, so upgrading to a newer version might be
# possible even if bugseverywhere-1.1.1 is broken (on pypi or elsewhere).
#
pythonPackages.buildPythonApplication rec {
    version = "1.1.1";
    name = "bugseverywhere-${version}";

    src = fetchurl {
      url =
      "mirror://pypi/b/bugs-everywhere/bugs-everywhere-${version}.tar.gz";
      sha256 = "1ikm3ckwpimwcvx32vy7gh5gbp7q750j3327m17nvrj99g3daz2d";
    };

    # There are no tests in the repository.
    doCheck = false;

    postInstall = ''
      mkdir -p $out/{${pythonPackages.python.sitePackages},bin}/
      cp libbe* -r $out/${pythonPackages.python.sitePackages}/

      cp be $out/bin/
      chmod +x $out/bin/be
    '';


    propagatedBuildInputs = with pythonPackages; [
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

