{ stdenv, python3, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "stgit";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "ctmarinas";
    repo = "stgit";
    rev = "v${version}";
    sha256 = "0xpvs5fa50rrvl2c8naha1nblk5ip2mgg63a9srqqxfx6z8qmrfz";
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
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.unix;
  };
}
