{ stdenv, fetchFromGitHub, python2, git }:

let
  name = "stgit-${version}";
  version = "0.21";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "16gwdad18rc9bivyzrjccp83iccmqr45fp2zawycmrfp2ancffc7";
  };

  buildInputs = [ python2 git ];

  makeFlags = [ "prefix=$$out" ];

  postInstall = ''
    mkdir -p "$out/etc/bash_completion.d/"
    ln -s ../../share/stgit/completion/stgit-completion.bash "$out/etc/bash_completion.d/"
  '';

  doCheck = false;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A patch manager implemented on top of Git";
    homepage = http://procode.org/stgit/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
