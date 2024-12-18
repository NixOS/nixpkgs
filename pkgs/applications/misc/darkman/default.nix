{ lib
, fetchFromGitLab
, buildGoModule
, scdoc
, nix-update-script
}:

buildGoModule rec {
  pname = "darkman";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${version}";
    sha256 = "sha256-FaEpVy/0PqY5Bmw00hMyFZb9wcwYwEuCKMatYN8Xk3o=";
  };

  patches = [
    ./go-mod.patch
    ./makefile.patch
  ];

  postPatch = ''
    substituteInPlace darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
  '';

  vendorHash = "sha256-3lILSVm7mtquCdR7+cDMuDpHihG+gDJTcQa1cM2o7ZU=";
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

  meta = with lib; {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = licenses.isc;
    maintainers = [ maintainers.ajgrf ];
    platforms = platforms.linux;
    mainProgram = "darkman";
  };
}
