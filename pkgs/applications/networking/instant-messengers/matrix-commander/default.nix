{ stdenv, lib, fetchFromGitHub, cacert, python3 }:

stdenv.mkDerivation {
  pname = "matrix-commander";
  version = "unstable-2021-05-26";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "06b4738bc74ee86fb3ac88c04b8230abf82e7421";
    sha256 = "1skpq3xfnz11m298qnsw68xv391p5qg47flagzsk86pnzi841vc1";
  };

  buildInputs = [
    cacert
    (python3.withPackages(ps: with ps; [
      matrix-nio
      magic
      markdown
      pillow
      urllib3
      aiofiles
    ]))];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src/matrix-commander.py $out/bin/matrix-commander
    chmod +x $out/bin/matrix-commander

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.seb314 ];
  };
}
