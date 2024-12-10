{
  lib,
  fetchFromGitLab,
  buildGoModule,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "darkman";
  version = "1.5.4";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${version}";
    sha256 = "sha256-6SNXVe6EfVwcXH9O6BxNw+v4/uhKhCtVS3XE2GTc2Sc=";
  };

  vendorHash = "sha256-xEPmNnaDwFU4l2G4cMvtNeQ9KneF5g9ViQSFrDkrafY=";

  nativeBuildInputs = [ scdoc ];

  postPatch = ''
    substituteInPlace darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
    substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
    substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
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
