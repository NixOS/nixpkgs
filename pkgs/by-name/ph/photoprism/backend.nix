{
  lib,
  buildGoModule,
  coreutils,
  python3,
  src,
  version,
  pkg-config,
  vips,
  symlinkJoin,
}:

let
  # we need to copy these, to add the symlinks, so the linker actually finds these libraries
  libtensorflow = symlinkJoin {
    name = "libtensorflow";
    paths = [ "${python3.pkgs.tensorflow-bin}/${python3.sitePackages}/tensorflow" ];
    postBuild = ''
      ln -s "$out/libtensorflow_cc.so.2" "$out/libtensorflow.so"
      ln -s "$out/libtensorflow_framework.so.2" "$out/libtensorflow_framework.so"
    '';
  };
in
buildGoModule {
  inherit src version;
  pname = "photoprism-backend";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    coreutils
    libtensorflow
    vips
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postPatch = ''
    substituteInPlace internal/commands/passwd.go --replace-fail '/bin/stty' "${coreutils}/bin/stty"
  '';

  vendorHash = "sha256-nOytOKceVuRryixDxx791my0JkdLPfyYdK6dAUG4CQc=";

  subPackages = [ "cmd/photoprism" ];

  # https://github.com/mattn/go-sqlite3/issues/822
  CGO_CFLAGS = "-Wno-return-local-addr -I${libtensorflow}/include";

  CGO_LDFLAGS = "-L${libtensorflow} -ltensorflow_framework";

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's backend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ benesim ];
  };
}
