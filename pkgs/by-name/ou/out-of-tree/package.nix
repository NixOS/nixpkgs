{
  lib,
  buildGoModule,
  fetchgit,
  qemu,
  podman,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "out-of-tree";
  version = "2.1.1";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchgit {
    tag = "v${finalAttrs.version}";
    url = "https://code.dumpstack.io/tools/out-of-tree.git";
    hash = "sha256-XzO8NU7A5m631PjAm0F/K7qLrD+ZDSdHXaNowGaZAPo=";
  };

  vendorHash = "sha256-p1dqzng3ak9lrnzrEABhE1TP1lM2Ikc8bmvp5L3nUp0=";

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/out-of-tree \
      --prefix PATH : "${
        lib.makeBinPath [
          qemu
          podman
        ]
      }"
  '';

  meta = {
    description = "Kernel {module, exploit} development tool";
    mainProgram = "out-of-tree";
    homepage = "https://out-of-tree.io";
    maintainers = [ lib.maintainers.dump_stack ];
    license = lib.licenses.agpl3Plus;
  };
})
