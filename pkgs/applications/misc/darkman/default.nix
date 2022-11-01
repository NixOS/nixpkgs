{ lib, fetchFromGitLab, buildGoModule, scdoc, nix-update-script }:

buildGoModule rec {
  pname = "darkman";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${version}";
    sha256 = "sha256-Q/pjQmlyREl32C0LiwypEz1qBw2AeBOZbUIwNP392Sc=";
  };

  vendorSha256 = "09rjqw6v1jaf0mhmycw9mcay9q0y1fya2azj8216gdgkl48ics08";

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

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = licenses.isc;
    maintainers = [ maintainers.ajgrf ];
  };
}
