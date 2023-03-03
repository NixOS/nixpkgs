{ bash
, binutils
, buildGoModule
, fetchFromGitHub
, kbd
, lib
, libfido2
, lvm2
, lz4
, makeWrapper
, mdadm
, unixtools
, xz
, zfs
}:

buildGoModule rec {
  pname = "booster";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "anatol";
    repo = pname;
    rev = version;
    hash = "sha256-kalVFVBb+ngoUpm+iiIHGS6vBVLEvTVyKuSMSMbp7Qc=";
  };

  vendorHash = "sha256-GD+nsT4/Y2mTF+ztOC3N560BY5+QSfsPrXZ+dJYtzAw=";

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

  postInstall = let
    runtimeInputs = [ bash binutils kbd libfido2 lvm2 mdadm zfs ];
  in ''
    wrapProgram $out/bin/generator --prefix PATH : ${lib.makeBinPath runtimeInputs}
    wrapProgram $out/bin/init --prefix PATH : ${lib.makeBinPath runtimeInputs}
  '';

  meta = with lib; {
    description = "Fast and secure initramfs generator ";
    homepage = "https://github.com/anatol/booster";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "init";
  };
}
