{
  lib,
  fetchFromGitLab,
  buildGoModule,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "darkman";
  version = "2.3.0";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${version}";
    hash = "sha256-KkO0s+TY9dRf8sYkEdg8sLtIxuU/tXHGo0V+FpByAkA=";
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
}
