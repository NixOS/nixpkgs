{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  docker,
  util-linux,
  udev,
  parted,
  e2fsprogs,
  dosfstools,
  mount,
  gnutar,
  syslinux,
  qemu-utils,
  multipath-tools,
  sparsecat,
  qemu,
  virtualbox,
  qemuSupport ? false,
  virtualboxSupport ? false,
}:

buildGoModule rec {
  pname = "d2vm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "linka-cloud";
    repo = "d2vm";
    rev = "v${version}";
    hash = "sha256-cSl9WfJIbnl3WyUTQjgCukhQ91uIyGB2xFPr5VF8E/U=";
  };

  subPackages = [ "cmd/d2vm" ];

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-pzO1qCRWR6+Htv+RZT8ZI+MUYkMumODushp/iUIc114=";

  preBuild = ''
    cp ${sparsecat}/bin/sparsecat cmd/d2vm/run/sparsecat-linux-amd64
    cp ${sparsecat}/bin/sparsecat cmd/d2vm/run/sparsecat-linux-arm64
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postPatch = ''
    substituteInPlace builder.go \
      --replace /usr/lib/syslinux/mbr/mbr.bin ${syslinux}/share/syslinux/mbr.bin
  '';

  postInstall = ''
    wrapProgram $out/bin/d2vm \
      --suffix PATH : ${
        lib.makeBinPath (
          [
            docker
            util-linux
            udev
            parted
            e2fsprogs
            dosfstools
            mount
            gnutar
            syslinux
            qemu-utils
            multipath-tools
          ]
          ++ lib.optionals qemuSupport [ qemu ]
          ++ lib.optionals virtualboxSupport [ virtualbox ]
        )
      }
  '';

  meta = {
    description = "Build Virtual Machine Image from Dockerfile or Docker image";
    homepage = "https://github.com/linka-cloud/d2vm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilimnik ];
  };
}
