{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper, wget }:

stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = pname;
    rev = version;
    sha256 = "sha256-6VsQLouK9gwBwbTdprtOgcBKJ0VD8pC/h49AcjS4F3U=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall

    # https://github.com/89luca89/distrobox/issues/408
    substituteInPlace ./distrobox-generate-entry \
      --replace 'icon_default="''${HOME}/.local' "icon_default=\"$out"
    ./install -P $out

    runHook postInstall
  '';

  # https://github.com/89luca89/distrobox/issues/407
  postFixup = ''
    wrapProgram "$out/bin/distrobox-generate-entry" \
      --prefix PATH ":" ${lib.makeBinPath [ wget ]}
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
