{ stdenv
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
}:

buildGoModule rec {
  pname = "cri-o";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "cri-o";
    repo = "cri-o";
    rev = "v${version}";
    sha256 = "0p6gprbs54v3n09fjpyfxnzxs680ms8924wdim4q9qw52wc6sbdz";
  };
  vendorSha256 = null;
  outputs = [ "out" "man" ];
  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
  ] ++ stdenv.lib.optionals (glibc != null) [ glibc glibc.static ];

  BUILDTAGS = "apparmor seccomp selinux containers_image_openpgp containers_image_ostree_stub";
  buildPhase = ''
    patchShebangs .

    sed -i '/version.buildDate/d' Makefile

    make binaries docs BUILDTAGS="$BUILDTAGS"
  '';

  installPhase = ''
    install -Dm755 bin/* -t $out/bin

    for shell in bash fish zsh; do
      installShellCompletion --$shell completions/$shell/*
    done

    installManPage docs/*.[1-9]
  '';

  meta = with stdenv.lib; {
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
