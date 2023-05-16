{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, libseccomp
, systemd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "conmon";
<<<<<<< HEAD
  version = "2.1.8";
=======
  version = "2.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gdMNAU+w4u+9DZL9x96OAZihShkQdvSiqPCA+eNf600=";
=======
    hash = "sha256-W6nqhSEoP2mDp7fCoXqwYAafjfESxymYXAdC3BnJJno=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libseccomp systemd ]
<<<<<<< HEAD
    ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];
=======
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # manpage requires building the vendored go-md2man
  makeFlags = [ "bin/conmon" ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/conmon/releases/tag/${src.rev}";
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
