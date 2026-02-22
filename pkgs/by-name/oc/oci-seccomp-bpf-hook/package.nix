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

buildGoModule (finalAttrs: {
  pname = "oci-seccomp-bpf-hook";
  version = "1.2.11";
  src = fetchFromGitHub {
    owner = "containers";
    repo = "oci-seccomp-bpf-hook";
    rev = "v${finalAttrs.version}";
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

  meta = {
    homepage = "https://github.com/containers/oci-seccomp-bpf-hook";
    description = ''
      OCI hook to trace syscalls and generate a seccomp profile
    '';
    mainProgram = "oci-seccomp-bpf-hook";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
  };
})
