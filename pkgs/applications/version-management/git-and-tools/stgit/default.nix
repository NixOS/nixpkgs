{ stdenv, python3, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "1r9y8qnl6kdvq61788pnfhhgyv2xrnyrizbhy4qz4l1bpqkwfr2r";
  };

  nativeBuildInputs = [ git ];

  makeFlags = [ "prefix=$$out" ];

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d/"
    ln -s ../../share/stgit/completion/stgit-completion.bash "$out/etc/bash_completion.d/"
  '';

  doCheck = false;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A patch manager implemented on top of Git";
    homepage = "http://procode.org/stgit/";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
