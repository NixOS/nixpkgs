{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  installShellFiles,
  pkg-config,
  bcc,
  libseccomp,
}:

buildGoModule rec {
  pname = "oci-seccomp-bpf-hook";
  version = "1.2.11";
  src = fetchFromGitHub {
    owner = "containers";
    repo = "oci-seccomp-bpf-hook";
    rev = "v${version}";
    sha256 = "sha256-1LRwbKOLNBkY/TMTLlWq2lkFzCabXqwdaMRT9HNr6HE=";
  };
  vendorHash = null;

  outputs = [
    "out"
    "man"
  ];
  nativeBuildInputs = [
    go-md2man
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    bcc
    libseccomp
  ];

  checkPhase = ''
    go test -v ./...
  '';

  buildPhase = ''
    make
  '';

  postBuild = ''
    substituteInPlace oci-seccomp-bpf-hook.json --replace HOOK_BIN_DIR "$out/bin"
  '';

  installPhase = ''
    install -Dm755 bin/* -t $out/bin
    install -Dm644 oci-seccomp-bpf-hook.json -t $out
    installManPage docs/*.[1-9]
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/containers/oci-seccomp-bpf-hook";
    description = ''
      OCI hook to trace syscalls and generate a seccomp profile
    '';
    mainProgram = "oci-seccomp-bpf-hook";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
