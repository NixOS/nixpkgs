{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "brig";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "brig";
    rev = "v${finalAttrs.version}";
    sha256 = "0gi39jmnzqrgj146yw8lcmgmvzx7ii1dgw4iqig7kx8c0jiqi600";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ]
  ++ lib.mapAttrsToList (n: v: "-X github.com/sahib/brig/version.${n}=${v}") {
    Major = lib.versions.major finalAttrs.version;
    Minor = lib.versions.minor finalAttrs.version;
    Patch = lib.versions.patch finalAttrs.version;
    ReleaseType = "";
    BuildTime = "1970-01-01T00:00:00+0000";
    GitRev = finalAttrs.src.rev;
  };

  postInstall = ''
    installShellCompletion --cmd brig \
      --bash $src/autocomplete/bash_autocomplete \
      --zsh $src/autocomplete/zsh_autocomplete
  '';

  # There are no tests for the brig executable.
  doCheck = false;

  meta = {
    description = "File synchronization on top of IPFS with a git-like interface and a FUSE filesystem";
    longDescription = ''
      brig is a distributed and secure file synchronization tool with a version
      control system. It is based on IPFS, written in Go and will feel familiar
      to git users. Think of it as a swiss army knife for file synchronization
      or as a peer to peer alternative to Dropbox.
    '';
    homepage = "https://brig.readthedocs.io";
    changelog = "https://github.com/sahib/brig/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "brig";
  };
})
