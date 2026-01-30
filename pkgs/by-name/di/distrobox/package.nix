{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  wget,
  gnugrep,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "distrobox";
  version = "1.8.2.3";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "distrobox";
    tag = finalAttrs.version;
    hash = "sha256-p/IQ6HWG01UPbiskp3u1UUm8YEnpY9jUGqqODrYS1Ck=";
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

    wrapProgram "$out/bin/${finalAttrs.meta.mainProgram}" \
      --prefix PATH ":" ${lib.makeBinPath [ gnugrep ]}

    mkdir -p $out/share/distrobox
    echo 'container_additional_volumes="/nix:/nix"' > $out/share/distrobox/distrobox.conf
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Wrapper around podman or docker to create and start containers";
    longDescription = ''
      Use any linux distribution inside your terminal. Enable both backward and
      forward compatibility with software and freedom to use whatever distribution
      you’re more comfortable with
    '';
    homepage = "https://distrobox.it/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ atila ];
    mainProgram = "distrobox";
  };
})
