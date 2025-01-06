{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  wget,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "distrobox";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    rev = finalAttrs.version;
    hash = "sha256-e9oSTk+UlkrkRSipqjjMqwtxEvEZffVBmlSTmsIT7cU=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    # https://github.com/89luca89/distrobox/issues/408
    ./relative-default-icon.patch
  ];

  installPhase = ''
    runHook preInstall

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
