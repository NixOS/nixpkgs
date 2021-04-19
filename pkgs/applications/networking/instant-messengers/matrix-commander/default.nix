{ pkgs, fetchFromGitHub, lib }:

pkgs.stdenv.mkDerivation {
  name = "matrix-commander";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "379bc7446f790eaf5b3b54225ad65e0f0c78637d";
    sha256 = "1cny7z793ln4xgf7cbgfd0jd4hi8mp8qr91siqjhy0nmyd9lmszv";
  };

  propagatedBuildInputs = [
    pkgs.cacert ] ++
    (with pkgs.python38Packages; [
      matrix-nio
      magic
      markdown
      pillow
      urllib3
    ]);

  installPhase = ''
    mkdir -p $out/bin
    cp $src/matrix-commander.py $out/bin/matrix-commander
    chmod +x $out/bin/matrix-commander
  '';

  meta = {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.seb314 ];
  };
}
