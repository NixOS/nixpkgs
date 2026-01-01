{
  lib,
  fetchFromGitLab,
  buildGoModule,
  scdoc,
  nix-update-script,
}:

buildGoModule rec {
  pname = "darkman";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Kpuuxxwn/huA5WwmnVGG0HowNBGyexDRpdUc3bNmB18=";
  };

  patches = [
=======
    hash = "sha256-FaEpVy/0PqY5Bmw00hMyFZb9wcwYwEuCKMatYN8Xk3o=";
  };

  patches = [
    ./go-mod.patch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ./makefile.patch
  ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace contrib/darkman.service \
=======
    substituteInPlace darkman.service \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
    substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
      --replace-fail /usr/bin/darkman $out/bin/darkman
  '';

<<<<<<< HEAD
  vendorHash = "sha256-QO+fz8m2rILKTokimf+v4x0lon5lZy7zC+5qjTMdcs0=";
=======
  vendorHash = "sha256-3lILSVm7mtquCdR7+cDMuDpHihG+gDJTcQa1cM2o7ZU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ajgrf ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = licenses.isc;
    maintainers = [ maintainers.ajgrf ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "darkman";
  };
}
