{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, pafy, pyperclip }:

buildPythonPackage rec {
  name = "mps-youtube-${version}";
  version = "0.2.7.1-20170828";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "mps-youtube";
    rev = "6b03b67685165790a5fb238d82a16421cf81458a";
    sha256 = "0dqwj1dzbzgkqqhvia2r5jkgaa7r3vdcxb8jmp70rbliv1ylz56q";
  };

  propagatedBuildInputs = [ pafy pyperclip ];

  # before check create a directory and redirect XDG_CONFIG_HOME to it
  preCheck = ''
    mkdir -p check-phase
    export XDG_CONFIG_HOME=$(pwd)/check-phase
  '';

  # disabled due to error in loading unittest
  # don't know how to make test from: <mps_youtube. ...>
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terminal based YouTube player and downloader";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ odi ];
  };
}
