{
  lib,
  stdenv,
  fetchurl,
  dosfstools,
  libseccomp,
  makeWrapper,
  mtools,
  parted,
  pkg-config,
  qemu_test,
  syslinux,
  util-linux,
}:

let
  version = "0.9.3";
  # list of all theoretically available targets
  targets = [
    "genode"
    "hvt"
    "muen"
    "spt"
    "virtio"
    "xen"
  ];
in
stdenv.mkDerivation {
  pname = "solo5";
  inherit version;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = lib.optional (stdenv.hostPlatform.isLinux) libseccomp;

  src = fetchurl {
    url = "https://github.com/Solo5/solo5/releases/download/v${version}/solo5-v${version}.tar.gz";
    hash = "sha256-KbeY667Y/ZPUuRIGYOZMMAuVEVJ7Kn9UDUSThX5zfII=";
  };

  configurePhase = ''
    runHook preConfigure
    sh configure.sh --prefix=/
    runHook postConfigure
  '';

  enableParallelBuilding = true;

  separateDebugInfo = true;
  # debugging requires information for both the unikernel and the tender

  installPhase = ''
    runHook preInstall
    export DESTDIR=$out
    export PREFIX=$out
    make install

    substituteInPlace $out/bin/solo5-virtio-mkimage \
      --replace "/usr/lib/syslinux" "${syslinux}/share/syslinux" \
      --replace "/usr/share/syslinux" "${syslinux}/share/syslinux" \
      --replace "cp " "cp --no-preserve=mode "

    wrapProgram $out/bin/solo5-virtio-mkimage \
      --prefix PATH : ${
        lib.makeBinPath [
          dosfstools
          mtools
          parted
          syslinux
        ]
      }

    runHook postInstall
  '';

  doCheck = stdenv.hostPlatform.isLinux;
  nativeCheckInputs = [
    util-linux
    qemu_test
  ];
  checkPhase = ''
    runHook preCheck
    patchShebangs tests
    substituteInPlace scripts/virtio-run/solo5-virtio-run.sh \
      --replace " -no-acpi" ""
    ./tests/bats-core/bats ./tests/tests.bats
    runHook postCheck
  '';

  meta = with lib; {
    description = "Sandboxed execution environment";
    homepage = "https://github.com/solo5/solo5";
    license = licenses.isc;
    platforms = mapCartesianProduct ({ arch, os }: "${arch}-${os}") {
      arch = [
        "aarch64"
        "x86_64"
      ];
      os = [
        "freebsd"
        "genode"
        "linux"
        "openbsd"
      ];
    };
  };

}
