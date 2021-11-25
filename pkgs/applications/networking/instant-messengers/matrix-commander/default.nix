{ stdenv, lib, fetchFromGitHub, cacert, python3 }:

stdenv.mkDerivation {
  pname = "matrix-commander";
  version = "unstable-2021-08-05";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "7ab3fd9a0ef4eb19d882cb3701d2025b4d41b63a";
    sha256 = "sha256-WWf7GbJxGlqIdsS1d0T1DO0WN2RBepHGgJrl/nt7UIg=";
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
      notify2
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
