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
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "sha256-/AoZKeUcYF1fyYtllXpB7GNWR/6SWEOy2ffDLYbTp9E=";
  };
  vendorSha256 = null;

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
