{
  lib,
  fetchFromGitLab,
  buildGoModule,
  scdoc,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "darkman";
  version = "2.3.1";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dQyFOdJbiijbAMWR63i2sMGuQAsJk8rmM/xnmYeWfOY=";
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

  vendorHash = "sha256-6wH2mE3pr4C4CoroNXd+OUjnOZ8xr7SrJfNCJX4t8Gs=";
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
