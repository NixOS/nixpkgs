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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "stackexchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "1plwdmzds6dq2rlp84dgiashrfg0kg4yijhnxaapz2q4d1vvx8lq";
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
      --replace 'PATH="''${blackbox_home}:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/local/bin:/usr/pkg/bin:/usr/pkg/gnu/bin:''${blackbox_home}"' \
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
