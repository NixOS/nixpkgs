{ stdenv, fetchFromGitHub, python2, git }:

let
  name = "stgit-${version}";
  version = "0.20";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "0zfrs9f6a84z5gr3k6y81h8jyar7h3q3z9p13cbrq9slljg5r6iw";
  };

  buildInputs = [ python2 git ];

  makeFlags = "prefix=$$out";

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
