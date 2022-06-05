{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = pname;
    rev = version;
    sha256 = "sha256-31SDi9B6Ug6lRDMgaMp6lwdSsmQ7ywEwjG1Ez/jXjBc=";
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
