{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoWrapElectronHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docker-desktop";
  version = "4.46.0";
  buildNumber = "204649";

  src = fetchurl (
    {
      # https://desktop.docker.com/linux/main/amd64/appcast.xml
      x86_64-linux = {
        url = "https://desktop.docker.com/linux/main/amd64/${finalAttrs.buildNumber}/docker-desktop-amd64.deb";
        hash = "sha256-C3OSnN+SuF5hTCFBQY+M3mwZv1bL1GXrbqWiYmxoPNE=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
  );

  postPatch = ''
    substituteInPlace "usr/lib/systemd/user/docker-desktop.service" \
      --replace-fail "/opt/docker-desktop/bin/com.docker.backend" "$out/lib/docker-desktop/bin/com.docker.backend"

    rm opt/docker-desktop/*.so*
  '';

  strictDeps = true;
  nativeBuildInputs = [ autoWrapElectronHook ] ++
    lib.optionals stdenvNoCC.hostPlatform.isLinux [
      # autoPatchelfHook
      dpkg
    ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"

    mv usr/share "$out/share"

    mv opt/docker-desktop "$out/lib/docker-desktop"
    mv usr/lib/docker "$out/lib/docker"
    mv usr/lib/systemd "$out/lib/systemd"

    mkdir -p "$out/bin"
    ln -s "$out/lib/docker-desktop/bin/docker-desktop" "$out/bin/docker-desktop"

    runHook postInstall
  '';

  meta = {
    description = "a straightforward Graphical User Interface that lets you manage your containers, applications, and images";
    license = {
      fullName = "Docker Subscription Service Agreement";
      url = "https://www.docker.com/legal/docker-subscription-service-agreement/";
      free = true;
    };
    mainProgram = "docker-desktop";
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = lib.platforms.linux;
  };
})
