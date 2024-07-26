{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper, wget }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "distrobox";
  version = "1.6.0.1";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    rev = finalAttrs.version;
    hash = "sha256-UWrXpb20IHcwadPpwbhSjvOP1MBXic5ay+nP+OEVQE4=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  # https://github.com/89luca89/distrobox/pull/1080
  patches = [ ./always-mount-nix.patch ];

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

    mkdir -p $out/share/distrobox
    echo 'container_additional_volumes="/nix:/nix"' > $out/share/distrobox/distrobox.conf
  '';

  meta = with lib; {
    description = "Wrapper around podman or docker to create and start containers";
    longDescription = ''
      Use any linux distribution inside your terminal. Enable both backward and
      forward compatibility with software and freedom to use whatever distribution
      you’re more comfortable with
    '';
    homepage = "https://distrobox.it/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ atila ];
  };
})
