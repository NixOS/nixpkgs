{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper, wget }:

stdenvNoCC.mkDerivation rec {
  pname = "distrobox";
<<<<<<< HEAD
  version = "1.5.0.2";
=======
  version = "1.4.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ss8049D6n1V/gDzEMjywDnoke5s2we9j3mO8yta72UA=";
=======
    sha256 = "sha256-s3lq1Xr2y29cmyT1nY5/amiDA9dNfyGaMtjTvUINSD8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    platforms = platforms.linux;
=======
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ atila ];
  };
}
