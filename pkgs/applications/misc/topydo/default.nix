{ lib, python3Packages, fetchFromGitHub, fetchpatch, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "topydo";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "bram85";
    repo = pname;
    rev = version;
    sha256 = "1lpfdai0pf90ffrzgmmkadbd86rb7250i3mglpkc82aj6prjm6yb";
  };

  patches = [
    # fixes a failing test
    (fetchpatch {
      name = "update-a-test-reference-ics-file.patch";
      url = "https://github.com/topydo/topydo/commit/9373bb4702b512b10f0357df3576c129901e3ac6.patch";
      hash = "sha256-JpyQfryWSoJDdyzbrESWY+RmRbDw1myvTlsFK7+39iw=";
    })
  ];

  propagatedBuildInputs = [
    arrow
    icalendar
    glibcLocales
    prompt-toolkit
    urwid
    watchdog
  ];

  nativeCheckInputs = [ unittestCheckHook mock freezegun pylint ];

  # Skip test that has been reported multiple times upstream without result:
  # bram85/topydo#271, bram85/topydo#274.
  preCheck = ''
    substituteInPlace test/test_revert_command.py --replace 'test_revert_ls' 'dont_test_revert_ls'
  '';

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A cli todo application compatible with the todo.txt format";
    homepage = "https://github.com/bram85/topydo";
    license = licenses.gpl3;
  };
}
