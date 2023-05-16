{ lib
, stdenv
, fetchFromGitHub
, expect
, which
, gnupg
, coreutils
, git
, pinentry
, gnutar
, procps
}:

stdenv.mkDerivation rec {
  pname = "blackbox";
<<<<<<< HEAD
  version = "1.20220610";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stackexchange";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-g0oNV7Nj7ZMmsVQFVTDwbKtF4a/Fb3WDB+NRx9IGSWA=";
=======
    sha256 = "1plwdmzds6dq2rlp84dgiashrfg0kg4yijhnxaapz2q4d1vvx8lq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ gnupg ];

  # https://github.com/NixOS/nixpkgs/issues/134445
  doCheck = !stdenv.isDarwin && stdenv.isx86_64;

  nativeCheckInputs = [
    expect
    which
    coreutils
    pinentry.tty
    git
    gnutar
    procps
  ];

  postPatch = ''
    patchShebangs bin tools
    substituteInPlace Makefile \
      --replace "PREFIX?=/usr/local" "PREFIX=$out"

    substituteInPlace tools/confidence_test.sh \
<<<<<<< HEAD
      --replace 'PATH="''${blackbox_home}:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/local/bin:/usr/pkg/bin:/usr/pkg/gnu/bin:/usr/local/MacGPG2/bin:/opt/homebrew/bin:''${blackbox_home}"' \
=======
      --replace 'PATH="''${blackbox_home}:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/local/bin:/usr/pkg/bin:/usr/pkg/gnu/bin:''${blackbox_home}"' \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        "PATH=/build/source/bin/:$PATH"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make copy-install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Safely store secrets in a VCS repo";
    maintainers = with maintainers; [ ericsagnes ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
