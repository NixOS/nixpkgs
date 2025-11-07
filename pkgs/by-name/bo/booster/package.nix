{
  bash,
  binutils,
  buildGoModule,
  fetchFromGitHub,
  kbd,
  lib,
  libfido2,
  lvm2,
  lz4,
  makeWrapper,
  mdadm,
  unixtools,
  xz,
  zfs,
}:

buildGoModule rec {
  pname = "booster";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "anatol";
    repo = "booster";
    tag = version;
    hash = "sha256-uHxPzuD3PxKAI2JOZd7lcLvcqYqk9gW9yeZgOS1Y7x4=";
  };

  vendorHash = "sha256-uI6TvBtky7Bpt4SbbtwT3vdMYbI/Awy3wgPfOla1qMw=";

  postPatch = ''
    substituteInPlace init/main.go --replace "/usr/bin/fsck" "${unixtools.fsck}/bin/fsck"
  '';

  # integration tests are run against the current kernel
  doCheck = false;

  nativeBuildInputs = [
    kbd
    lz4
    makeWrapper
    xz
  ];

  postInstall =
    let
      runtimeInputs = [
        bash
        binutils
        kbd
        libfido2
        lvm2
        mdadm
        zfs
      ];
    in
    ''
      wrapProgram $out/bin/generator --prefix PATH : ${lib.makeBinPath runtimeInputs}
      wrapProgram $out/bin/init --prefix PATH : ${lib.makeBinPath runtimeInputs}
    '';

  meta = with lib; {
    description = "Fast and secure initramfs generator";
    homepage = "https://github.com/anatol/booster";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "init";
  };
}
