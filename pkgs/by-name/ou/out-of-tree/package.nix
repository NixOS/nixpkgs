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
  version = "2.1.2";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchgit {
    tag = "v${finalAttrs.version}";
    url = "https://code.dumpstack.io/tools/out-of-tree.git";
    hash = "sha256-vf4XxyeJq1BPSYpqQiB5DMfbZdMbwsSsZhLWfaD6BB4=";
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
