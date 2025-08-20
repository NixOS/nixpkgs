{ lib
, writeShellScript
, fetchFromGitHub
, python3Packages # TODO@deliciouslytyped: This is overridden in all-packages to be python37 until upstream
                  # is fixed; python38 deprecates some functions WikidPad relies on, see:
                  # https://github.com/WikidPad/WikidPad/issues/77
, wrapGAppsHook
, sqlite
}: python3Packages.buildPythonApplication {
  pname = "wikidpad";
  version = "master-2019-07-31";

  doCheck = false; #TODO fails on build_ext when trying to build some windows module

  src = fetchFromGitHub {
    owner = "WikidPad";
    repo = "WikidPad";
    rev = "558109638807bc76b4672922686e416ab2d5f79c";
    hash = "sha256:0hrpzv4hhqi859af0zkik9rhwshk18wphvr6vwrs924h0dm3g3qa";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = (with python3Packages;
    [ setuptools
      wxPython_4_0 # Shouldn't be updated until https://github.com/WikidPad/WikidPad/issues/78
      six 
#      pillow numpy
    ]) ++ # TODO pillow and numpy shouldn't be needed here, they are not a direct dependency of WikidPad!
                         # wxPython 4_1 may have added requirements, going by the changelog? https://wxpython.org/pages/changes/index.html
                         # TODO figure out why this wasn't an issue for whoever made 4_1.
    [ sqlite ]; # NOTE: wikidpad uses its own ctypes wrapper for sqlite, using cdll.
                # This is why we add it to LD_LIBRARY_PATH in makeWrapperArgs.

  makeWrapperArgs = [ "--suffix LD_LIBRARY_PATH : ${lib.escapeShellArg (lib.makeLibraryPath [ sqlite ])}" ];

  meta = with lib; {
    description = "WikidPad is a Wiki-like notebook for storing your thoughts, ideas, todo lists, contacts, or anything else you can think of to write down.";
    homepage = "http://wikidpad.sourceforge.net/";
    license = with lib.licenses; [
      bsd3 # base application
      mit # bundled jQuery 2
      asl20 # whoosh
      lgpl21 # components listed in license-spelladdon.txt
      psfl # relativedelta.py
      wxWindows # WikidPad/lib/aui
    ];
    maintainers = with maintainers; [ deliciouslytyped ];
    platforms = platforms.linux; # Windows and MacOS are supported by upstream, but we don't support them (yet?).
    mainProgram = "wikidpad";
  };
}
