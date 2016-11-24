{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages, gocr, unrar, rhino, spidermonkey }:
pythonPackages.buildPythonApplication rec {
  version = "0.4.9-next";
  name = "pyLoad-" + version;

  src = fetchFromGitHub {
    owner = "pyload";
    repo = "pyload";
    rev = "03f3ad9e39da2b9a378987693c4a69720e4084c7";
    sha256 = "0fgsz6yzxrlq3qvsyxsyzgmy4za35v1xh3i4drhispk9zb5jm1xx";
  };

  patches =
    let
      # gets merged in next release version of pyload
      configParserPatch = fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/pyload/pyload/pull/2625.diff";
        sha256 = "1bisgx78kcr5c0x0i3h0ch5mykns5wx5wx7gvjj0pc71lfzlxzb9";
      };
      setupPyPatch = fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/pyload/pyload/pull/2638.diff";
        sha256 = "006g4qbl582262ariflbyfrszcx8ck2ac1cpry1f82f76p4cgf6z";
      };
    in [ configParserPatch setupPyPatch ];

  buildInputs = [
    unrar rhino spidermonkey gocr pythonPackages.paver
  ];

  propagatedBuildInputs = with pythonPackages; [
    pycurl jinja2 beaker thrift simplejson pycrypto feedparser tkinter
    beautifulsoup
  ];

  #remove this once the PR patches above are merged. Needed because githubs diff endpoint
  #does not support diff -N
  prePatch = ''
    touch module/config/__init__.py
  '';

  preBuild = ''
    paver generate_setup
  '';

  doCheck = false;

  meta = {
    description = "Free and open source downloader for 1-click-hosting sites";
    homepage = https://github.com/pyload/pyload;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.mahe ];
    platforms = stdenv.lib.platforms.all;
  };
}
