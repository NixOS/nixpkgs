{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = pname;
    rev = version;
    sha256 = "047mrhsfi88mgwylnnyxg6xa7hjjrajn2pf7vfmb6161myqybvfy";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ./install -p $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Wrapper around podman or docker to create and start containers";
    longDescription = ''
      Use any linux distribution inside your terminal. Enable both backward and
      forward compatibility with software and freedom to use whatever distribution
      you’re more comfortable with
    '';
    homepage = "https://distrobox.privatedns.org/";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ atila ];
  };
}
