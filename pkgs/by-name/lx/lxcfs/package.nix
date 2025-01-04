{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse3,
  help2man,
  makeWrapper,
  meson,
  ninja,
  nix-update-script,
  nixosTests,
  pkg-config,
  python3,
  util-linux,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "lxcfs";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = "v${version}";
    hash = "sha256-+Xlx1E6ggB/Vx3yOJGgh4UfEvaVyT7uOttaxelDA7Iw=";
  };

  patches = [
    # skip RPM spec generation
    ./no-spec.patch

    # skip installing systemd files
    ./skip-init.patch

    # fix pidfd checks and include
    ./pidfd.patch
  ];

  nativeBuildInputs = [
    meson
    help2man
    makeWrapper
    ninja
    (python3.pythonOnBuildForHost.withPackages (p: [ p.jinja2 ]))
    pkg-config
  ];
  buildInputs = [ fuse3 ];

  preConfigure = ''
    patchShebangs tools/
  '';

  postInstall = ''
    # `mount` hook requires access to the `mount` command from `util-linux` and `readlink` from `coreutils`:
    wrapProgram "$out/share/lxcfs/lxc.mount.hook" --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        util-linux
      ]
    }
  '';

  postFixup = ''
    # liblxcfs.so is reloaded with dlopen()
    patchelf --set-rpath "$(patchelf --print-rpath "$out/bin/lxcfs"):$out/lib" "$out/bin/lxcfs"
  '';

  passthru = {
    tests = {
      incus-lts = nixosTests.incus-lts.container;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "FUSE filesystem for LXC";
    mainProgram = "lxcfs";
    homepage = "https://linuxcontainers.org/lxcfs";
    changelog = "https://linuxcontainers.org/lxcfs/news/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxc.members;
  };
}
