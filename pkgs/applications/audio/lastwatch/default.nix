{ stdenv, fetchgit, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "lastwatch-${version}";
  namePrefix = "";
  version = "0.4.1";

  src = fetchgit {
    url = "git://github.com/aszlig/LastWatch.git";
    rev = "refs/tags/v${version}";
    sha256 = "0nlng3595j5jvnikk8i5hb915zak5zsmfn2306cc4gfcns9xzjwp";
  };

  propagatedBuildInputs = with python2Packages; [
    pyinotify
    pylast
    mutagen
  ];

  meta = {
    homepage = https://github.com/aszlig/LastWatch;
    description = "An inotify-based last.fm audio scrobbler";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
