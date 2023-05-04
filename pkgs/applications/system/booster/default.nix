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
  version = "0.10";

  src = fetchFromGitHub {
    owner = "anatol";
    repo = pname;
    rev = version;
    hash = "sha256-mUmh2oAD3G9cpv7yiKcFaXJkEdo18oMD/sttnYnAQL8=";
  };

  vendorHash = "sha256-czzNAUO4eRYTwfnidNLqyvIsR0nyzR9cb+G9/5JRvKs=";

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
