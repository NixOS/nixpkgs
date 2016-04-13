{ stdenv, fetchurl, buildPythonApplication, tempita, jinja2, pyyaml, clepy, mock
, nose, decorator, docutils
}:

# TODO: pitz has a pitz-shell utility that depends on ipython, but it just
# errors out and dies (it probably depends on an old ipython version):
#
#   from IPython.Shell import IPShellEmbed
#   ImportError: No module named Shell
#
# pitz-shell is not the primary interface, so it is not critical to have it
# working. Concider fixing pitz upstream.

buildPythonApplication rec {
  name = "pitz-1.2.4";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/p/pitz/${name}.tar.gz";
    sha256 = "1k7f3h4acllzqy3mjqnjd4w5jskp03s79b7dx3c85vlmd7824smr";
  };

  # propagatedBuildInputs is needed for pitz to find its dependencies at
  # runtime. If we use buildInputs it would just build, not run.
  propagatedBuildInputs = [ tempita jinja2 pyyaml clepy mock nose decorator docutils ];

  meta = with stdenv.lib; {
    description = "Distributed bugtracker";
    license = licenses.bsd3;
    homepage = http://pitz.tplus1.com/;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
