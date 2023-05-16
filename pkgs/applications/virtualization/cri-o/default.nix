{ lib
, btrfs-progs
, buildGoModule
, fetchFromGitHub
, glibc
, gpgme
, installShellFiles
, libapparmor
, libseccomp
, libselinux
, lvm2
, pkg-config
, nixosTests
}:

buildGoModule rec {
  pname = "cri-o";
<<<<<<< HEAD
  version = "1.28.1";
=======
  version = "1.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4RwR4aM+h0cqogJ9sxoODlPGaXH2PALFoBU3jv/6Agg=";
=======
    sha256 = "sha256-ZFt8KcEJ7iN2JgKbOGDgpq0+pjlxEU7V9GSX+c3VnbY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  vendorHash = null;

  doCheck = false;

  outputs = [ "out" "man" ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
  ] ++ lib.optionals (glibc != null) [ glibc glibc.static ];

  BUILDTAGS = "apparmor seccomp selinux containers_image_openpgp containers_image_ostree_stub";
  buildPhase = ''
    runHook preBuild
    make binaries docs BUILDTAGS="$BUILDTAGS"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/* -t $out/bin

    for shell in bash fish zsh; do
      installShellCompletion --$shell completions/$shell/*
    done

    install contrib/cni/*.conflist -Dt $out/etc/cni/net.d
    install crictl.yaml -Dt $out/etc

    installManPage docs/*.[1-9]
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) cri-o; };

  meta = with lib; {
    homepage = "https://cri-o.io";
    description = ''
      Open Container Initiative-based implementation of the
      Kubernetes Container Runtime Interface
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
