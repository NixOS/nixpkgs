{
  lib,
  fetchFromGitLab,
  buildGoModule,
  scdoc,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "darkman";
  version = "2.2.0";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Kpuuxxwn/huA5WwmnVGG0HowNBGyexDRpdUc3bNmB18=";
  };

  patches = [
    ./makefile.patch
  ];

  postPatch = ''
    substituteInPlace contrib/darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
  '';

  vendorHash = "sha256-QO+fz8m2rILKTokimf+v4x0lon5lZy7zC+5qjTMdcs0=";
  nativeBuildInputs = [ scdoc ];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 darkman -t $out/bin
    make PREFIX=$out install
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ajgrf ];
    platforms = lib.platforms.linux;
    mainProgram = "darkman";
  };
})
