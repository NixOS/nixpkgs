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
<<<<<<< HEAD
  version = "0.11";
=======
  version = "0.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "anatol";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-+0pY4/f/qfIT1lLn2DXmJBZcDDEOil4H3zNY3911ACQ=";
  };

  vendorHash = "sha256-RmRY+HoNuijfcK8gNbOIyWCOa50BVJd3IZv2+Pc3FYw=";
=======
    hash = "sha256-mUmh2oAD3G9cpv7yiKcFaXJkEdo18oMD/sttnYnAQL8=";
  };

  vendorHash = "sha256-czzNAUO4eRYTwfnidNLqyvIsR0nyzR9cb+G9/5JRvKs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
