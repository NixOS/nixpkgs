{ stdenv, lib, fetchFromGitHub, cacert, python3 }:

stdenv.mkDerivation {
  pname = "matrix-commander";
  version = "unstable-2021-04-18";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "3e89a5f4c98dd191880ae371cc63eb9282d7d91f";
    sha256 = "08nwwszp1kv5b7bgf6mmfn42slxkyhy98x18xbn4pglc4bj32iql";
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
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.seb314 ];
  };
}
