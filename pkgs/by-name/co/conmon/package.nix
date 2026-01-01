{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  glibc,
  libseccomp,
<<<<<<< HEAD
  systemdMinimal,
  nixosTests,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  systemd,
  nixosTests,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "conmon";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Kt49c8a+R/+Z3KmFLpRTG+BdfPDAOEUtSis3alLAUQ=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > COMMIT
      rm -rf .git
    '';
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace-fail "(GIT_COMMIT)" "(shell cat COMMIT)"
  '';

=======
    rev = "v${version}";
    hash = "sha256-XsVWcJsUc0Fkn7qGRJDG5xrQAsJr6KN7zMy3AtPuMTo=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libseccomp
<<<<<<< HEAD
    systemdMinimal
=======
    systemd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [
    glibc
    glibc.static
  ];

  # manpage requires building the vendored go-md2man
  makeFlags = [
    "bin/conmon"
<<<<<<< HEAD
=======
    "VERSION=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) cri-o podman; };

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/containers/conmon/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/containers/conmon";
    description = "OCI container runtime monitor";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    mainProgram = "conmon";
  };
})
=======
  meta = with lib; {
    changelog = "https://github.com/containers/conmon/releases/tag/${src.rev}";
    homepage = "https://github.com/containers/conmon";
    description = "OCI container runtime monitor";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
    mainProgram = "conmon";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
