{
  lib,
  buildGoModule,
  fetchgit,
  qemu,
  podman,
  makeWrapper,
}:

buildGoModule rec {
  pname = "out-of-tree";
  version = "2.1.1";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchgit {
    tag = "v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
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

  meta = with lib; {
    description = "Kernel {module, exploit} development tool";
    mainProgram = "out-of-tree";
    homepage = "https://out-of-tree.io";
    maintainers = [ maintainers.dump_stack ];
    license = licenses.agpl3Plus;
  };
}
