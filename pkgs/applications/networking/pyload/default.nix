{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages, gocr, unrar, rhino, spidermonkey }:

let
  beautifulsoup = pythonPackages.callPackage ./beautifulsoup.nix {
    inherit pythonPackages;
  };

in pythonPackages.buildPythonApplication rec {
  version = "0.4.9-next";
  name = "pyLoad-" + version;

  src = fetchFromGitHub {
    owner = "pyload";
    repo = "pyload";
    rev = "721ea9f089217b9cb0f2799c051116421faac081";
    sha256 = "1ad4r9slx1wgvd2fs4plfbpzi4i2l2bk0lybzsb2ncgh59m87h54";
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
    beautifulsoup send2trash
  ];

  #remove this once the PR patches above are merged. Needed because githubs diff endpoint
  #does not support diff -N
  prePatch = ''
    touch module/config/__init__.py
  '';

  preBuild = ''
    ${pythonPackages.paver}/bin/paver generate_setup
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Free and open source downloader for 1-click-hosting sites";
    homepage = "https://github.com/pyload/pyload";
    license = licenses.gpl3;
    maintainers = [ maintainers.mahe ];
    platforms = platforms.all;
  };
}
